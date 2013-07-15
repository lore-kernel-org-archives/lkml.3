Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3GOP1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:27:25 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:58102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab3GOP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:27:23 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        hector.palacios@digi.com, Thomas Petazzoni <thomas@free-electrons.com>,
        plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/3] Few ignored framebuffer fixes/additions
Date: Mon, 15 Jul 2013 17:26:59 +0200
Message-Id: <1373902022-20439-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, 

Sorry to bother you again with the framebuffer stuff but the new
maintainer doesn't appear to be responsive either.k

This is a collection of patches that have been silently ignored,
despite being pinged numerous times:
  - Patch 1 has been sent for the first time on June 7 [1], resent on
    June 18 [2], plus two pings on July, 3rd [3] and July, 12th [4]. With
    no comments whatsoever.
  - Patch 2 has been sent on June, 21st [5]. Jean Christophe commented
    on it on June, 24th [6], but every attempts at getting clear
    explanations on what was expected have been ignored ever since
    (June 25th [7], July 12th [8])
  - Patch 3 was sent on June 21st along with Patch 2 [9]. There was
    comments on it and a second version was sent on June 24th
    [10]. Without any comments so far.

Could you take a look at those patches? We already missed 3.11, and
I'd really like not to miss another merge window because of the fbdev
curse.

Thanks,
Maxime

[1]: https://lkml.org/lkml/2013/6/7/116
[2]: https://lkml.org/lkml/2013/6/18/130
[3]: https://lkml.org/lkml/2013/7/3/105
[4]: https://lkml.org/lkml/2013/7/12/177
[5]: https://lkml.org/lkml/2013/6/21/405
[6]: https://lkml.org/lkml/2013/6/24/313
[7]: https://lkml.org/lkml/2013/6/25/274
[8]: https://lkml.org/lkml/2013/7/12/103
[9]: https://lkml.org/lkml/2013/6/21/407
[10]: https://lkml.org/lkml/2013/6/24/302

Alexandre Belloni (1):
  fb: backlight: HX8357: Add HX8369 support

Hector Palacios (1):
  video: mxsfb: fix color settings for 18bit data bus and 32bpp

Maxime Ripard (1):
  video: hx8357: Make IM pins optional

 drivers/video/backlight/hx8357.c | 255 +++++++++++++++++++++++++++++++++------
 drivers/video/mxsfb.c            |  26 ----
 2 files changed, 218 insertions(+), 63 deletions(-)

-- 
1.8.3.2

