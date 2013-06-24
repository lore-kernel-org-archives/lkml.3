Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3FXORU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:17:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36645 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:17:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-fbdev@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 0/2] HX8357 driver improvement
Date: Mon, 24 Jun 2013 16:16:53 +0200
Message-Id: <1372083415-9734-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a set of improvements for the hx8357 driver. The first patch removes the
need to defines IM pins in the device tree. So that it is possible to use the
controller with fixed IM pins.

The second patch adds support for the Himax HX8369 controller which is quite
similar.

Tested on CFA-10055 (hx8357) and CFA-10056 (hx8369).

Alexandre Belloni (1):
  fb: backlight: HX8357: Add HX8369 support

Maxime Ripard (1):
  video: hx8357: Make IM pins optional

 drivers/video/backlight/hx8357.c | 256 +++++++++++++++++++++++++++++++++------
 1 file changed, 219 insertions(+), 37 deletions(-)

-- 
1.8.1.2

