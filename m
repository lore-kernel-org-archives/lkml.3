Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaH0BId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:08:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32134 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaH0BIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:08:32 -0400
X-AuditID: cbfee68f-f797f6d000001173-97-53fd2f8ddae6
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 00/18] backlight: fix checkpatch warnings
Date: Wed, 27 Aug 2014 10:08:29 +0900
Message-id: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t8zfd1e/b/BBkv2GFgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBn3/69n
	LNgmUnH36T/GBsad/F2MHBwSAiYSE5pMuhg5gUwxiQv31rN1MXJxCAksY5Q41viWFSJhIvFo
	12ZGiMQiRoktrfuhqn4zSlyb+pENpIpNQE3iy5fD7CC2iICCxObeZ2DdzAK5Er9nrmQEsYUF
	bCTaf21lBtnMIqAq0bosFMTkFbCVuPuAGaSCV0BQ4sfkeywQnVoS63ceZ4Kw5SU2r3nLDHGz
	usSjv7oQi/Qkri1ewA5RIiKx78U7sDMlBDaxS2zv6gC7gEVAQOLb5EMsEL2yEpsOMEO8JSlx
	cMUNlgmMYrOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIhPXv
	YLx7wPoQowAHoxIP74cFf4KFWBPLiitzDzGaAl00kVlKNDkfGMd5JfGGxmZGFqYmpsZG5pZm
	SuK8C6V+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpg3PChrp35MZ/dCVYPwfiYqNrI3tun
	EmfsDohos896NWMHX7ND9l7ean8n3m+mEd9flZ2RE/X92hv0t+JwWJhvXMKvxybiV/emy51K
	uzurwdv3ykZW/jOaj10mJ8ktzzW8u1DhSf3OxfUymgpHPLPmr9nKpn0gkNHj5L4Uxg3MZk//
	B7WZWVspsRRnJBpqMRcVJwIARPBYXqsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd1e/b/BBm836lgc3TmRyeLywkus
	Fve/HmW0uLxrDpsDi8fOWXfZPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ9/+vZyzYJlJx9+k/xgbGnfxdjJwcEgImEo92bWaEsMUkLtxb
	z9bFyMUhJLCIUWJL634o5zejxLWpH9lAqtgE1CS+fDnMDmKLCChIbO59xgpiMwvkSvyeuRJs
	krCAjUT7r63MXYwcHCwCqhKty0JBTF4BW4m7D5hBKngFBCV+TL7HAtGpJbF+53EmCFteYvOa
	t2CdEgLqEo/+6kIs0pO4tngBO0SJiMS+F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOAIfia1g3Flg8UhRgEORiUe3o8L/gQLsSaWFVfmHmKU4GBW
	EuFNVvgbLMSbklhZlVqUH19UmpNafIjRFOjNicxSosn5wOSSVxJvaGxiZmRpZGZhZGJuriTO
	e6DVOlBIID2xJDU7NbUgtQimj4mDU6qBse0K80kOljcrOlr8F2yxEY1zzy62SFgkodmStKtg
	Jde7i/9iTlxafUV4lUvedi63KepKh6YXTLSfJPjtr86PWUYLerR+b9g04TTjHaUtEx8dyl95
	gjd+D9+x3IgY10Tn1NWiCz6fOrx7yfr1JqViz0uEa9ayfS7I2PKjRkMlWpRvlYjXgglhkUos
	xRmJhlrMRcWJAMprYPP2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes checkpatch warnings as follows.
There is no functional change.

   WARNING: Missing a blank line after declarations
   WARNING: else is not generally useful after a break or return
   WARNING: void function return statements are not generally useful

Changes for V2
- Added Lee Jones's Acked-by for 1~18th patches, except for 17th patch.
- Fixed 17th patch, per Lee Jones's feedback.
   
Jingoo Han (18)
      backlight: adp5520: add blank line after declarations
      backlight: adp8860: add blank line after declarations
      backlight: adp8870: add blank line after declarations
      backlight: ams369fg06: remove 'else' after a return
      backlight: corgi_lcd: add blank line after declarations
      backlight: cr_bllcd: add blank line after declarations
      backlight: ili922x: remove 'else' after a return
      backlight: ld9040: remove 'else' after a return
      backlight: lm3639: remove unnecessary return statements
      backlight: lms501kf03: remove 'else' after a return
      backlight: lp855x: add blank line after declarations
      backlight: pcf50633: add blank line after declarations
      backlight: s6e63m0: remove 'else' after a return
      backlight: tdo24m: add blank line after declarations
      backlight: wm831x_bl: add blank line after declarations
      backlight: jornada720: remove 'else' after a return
      backlight: jornada720: remove 'else' after a return
      backlight: omap1: add blank line after declarations
   
---
 drivers/video/backlight/adp5520_bl.c         |  1 +
 drivers/video/backlight/adp8860_bl.c         |  3 +++
 drivers/video/backlight/adp8870_bl.c         |  4 ++++
 drivers/video/backlight/ams369fg06.c         |  6 +++---
 drivers/video/backlight/corgi_lcd.c          |  1 +
 drivers/video/backlight/cr_bllcd.c           |  1 +
 drivers/video/backlight/ili922x.c            | 11 ++++++-----
 drivers/video/backlight/jornada720_bl.c      |  6 +++---
 drivers/video/backlight/jornada720_lcd.c     |  6 +-----
 drivers/video/backlight/ld9040.c             |  6 +++---
 drivers/video/backlight/lm3639_bl.c          |  2 --
 drivers/video/backlight/lms501kf03.c         | 12 ++++++------
 drivers/video/backlight/lp855x_bl.c          |  2 ++
 drivers/video/backlight/omap1_bl.c           |  1 +
 drivers/video/backlight/pcf50633-backlight.c |  1 +
 drivers/video/backlight/s6e63m0.c            | 12 ++++++------
 drivers/video/backlight/tdo24m.c             |  2 ++
 drivers/video/backlight/wm831x_bl.c          |  1 +
 18 files changed, 45 insertions(+), 33 deletions(-)


