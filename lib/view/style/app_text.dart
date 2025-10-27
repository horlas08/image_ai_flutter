import 'package:flutter/material.dart';

class AppText {
  // Base function for creating styles
  static TextStyle _style({
    required double size,
    required FontWeight weight,
    FontStyle style = FontStyle.normal,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
      height: 1.4, // Line height 140%
      letterSpacing: -0.2,
      color: color,
    );
  }

  // Colors
  static const Color _headingColor = Color(0xFF111827);
  static const Color _bodyColor = Color(0xFF1A1C1E);

  // ********** 12px **********
  static final regular12 = _style(size: 12, weight: FontWeight.w400, color: _bodyColor);
  static final medium12  = _style(size: 12, weight: FontWeight.w500, color: _bodyColor);
  static final semiBold12 = _style(size: 12, weight: FontWeight.w600, color: _headingColor);
  static final bold12    = _style(size: 12, weight: FontWeight.w700, color: _headingColor);

  static final italicRegular12 = _style(size: 12, weight: FontWeight.w400, style: FontStyle.italic, color: _bodyColor);
  static final italicMedium12  = _style(size: 12, weight: FontWeight.w500, style: FontStyle.italic, color: _bodyColor);
  static final italicSemiBold12 = _style(size: 12, weight: FontWeight.w600, style: FontStyle.italic, color: _headingColor);
  static final italicBold12    = _style(size: 12, weight: FontWeight.w700, style: FontStyle.italic, color: _headingColor);

  // ********** 14px **********
  static final regular14 = _style(size: 14, weight: FontWeight.w400, color: _bodyColor);
  static final medium14  = _style(size: 14, weight: FontWeight.w500, color: _bodyColor);
  static final semiBold14 = _style(size: 14, weight: FontWeight.w600, color: _headingColor);
  static final bold14    = _style(size: 14, weight: FontWeight.w700, color: _headingColor);

  static final italicRegular14 = _style(size: 14, weight: FontWeight.w400, style: FontStyle.italic, color: _bodyColor);
  static final italicMedium14  = _style(size: 14, weight: FontWeight.w500, style: FontStyle.italic, color: _bodyColor);
  static final italicSemiBold14 = _style(size: 14, weight: FontWeight.w600, style: FontStyle.italic, color: _headingColor);
  static final italicBold14    = _style(size: 14, weight: FontWeight.w700, style: FontStyle.italic, color: _headingColor);

  // ********** 16px **********
  static final regular16 = _style(size: 16, weight: FontWeight.w400, color: _bodyColor);
  static final medium16  = _style(size: 16, weight: FontWeight.w500, color: _bodyColor);
  static final semiBold16 = _style(size: 16, weight: FontWeight.w600, color: _headingColor);
  static final bold16    = _style(size: 16, weight: FontWeight.w700, color: _headingColor);

  static final italicRegular16 = _style(size: 16, weight: FontWeight.w400, style: FontStyle.italic, color: _bodyColor);
  static final italicMedium16  = _style(size: 16, weight: FontWeight.w500, style: FontStyle.italic, color: _bodyColor);
  static final italicSemiBold16 = _style(size: 16, weight: FontWeight.w600, style: FontStyle.italic, color: _headingColor);
  static final italicBold16    = _style(size: 16, weight: FontWeight.w700, style: FontStyle.italic, color: _headingColor);

  // ********** 18px **********
  static final regular18 = _style(size: 18, weight: FontWeight.w400, color: _bodyColor);
  static final medium18  = _style(size: 18, weight: FontWeight.w500, color: _bodyColor);
  static final semiBold18 = _style(size: 18, weight: FontWeight.w600, color: _headingColor);
  static final bold18    = _style(size: 18, weight: FontWeight.w700, color: _headingColor);

  static final italicRegular18 = _style(size: 18, weight: FontWeight.w400, style: FontStyle.italic, color: _bodyColor);
  static final italicMedium18  = _style(size: 18, weight: FontWeight.w500, style: FontStyle.italic, color: _bodyColor);
  static final italicSemiBold18 = _style(size: 18, weight: FontWeight.w600, style: FontStyle.italic, color: _headingColor);
  static final italicBold18    = _style(size: 18, weight: FontWeight.w700, style: FontStyle.italic, color: _headingColor);

  // ********** 20px **********
  static final regular20 = _style(size: 20, weight: FontWeight.w400, color: _bodyColor);
  static final medium20  = _style(size: 20, weight: FontWeight.w500, color: _bodyColor);
  static final semiBold20 = _style(size: 20, weight: FontWeight.w600, color: _headingColor);
  static final bold20    = _style(size: 20, weight: FontWeight.w700, color: _headingColor);

  static final italicRegular20 = _style(size: 20, weight: FontWeight.w400, style: FontStyle.italic, color: _bodyColor);
  static final italicMedium20  = _style(size: 20, weight: FontWeight.w500, style: FontStyle.italic, color: _bodyColor);
  static final italicSemiBold20 = _style(size: 20, weight: FontWeight.w600, style: FontStyle.italic, color: _headingColor);
  static final italicBold20    = _style(size: 20, weight: FontWeight.w700, style: FontStyle.italic, color: _headingColor);

  // ********** 24px **********
  static final regular24 = _style(size: 24, weight: FontWeight.w400, color: _bodyColor);
  static final medium24  = _style(size: 24, weight: FontWeight.w500, color: _bodyColor);
  static final semiBold24 = _style(size: 24, weight: FontWeight.w600, color: _headingColor);
  static final bold24    = _style(size: 24, weight: FontWeight.w700, color: _headingColor);

  static final italicRegular24 = _style(size: 24, weight: FontWeight.w400, style: FontStyle.italic, color: _bodyColor);
  static final italicMedium24  = _style(size: 24, weight: FontWeight.w500, style: FontStyle.italic, color: _bodyColor);
  static final italicSemiBold24 = _style(size: 24, weight: FontWeight.w600, style: FontStyle.italic, color: _headingColor);
  static final italicBold24    = _style(size: 24, weight: FontWeight.w700, style: FontStyle.italic, color: _headingColor);
}
