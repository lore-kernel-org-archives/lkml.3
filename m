Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3AYQ7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:59:52 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:48989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3AYQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:59:45 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 0/2] Improvement for pca953x drivers
Date: Fri, 25 Jan 2013 17:59:26 +0100
Message-Id: <1359133168-14879-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

those two patches are the begining of the improvement work we have
spoken about earlier. I started with the two patches you sent.

I've just made a small fix to make it build on the 2nd patch so I keep
your autorship and signed-off.

For the second one, it didn't build too, but I made a more substantial
change on it by moving the setting of the irq to the map function. So
for this one, I took the authorship and remove your signed-off to not
make you responsible of my possible bug! :)

I've compiled and run it, but as I don't have support for the pca905
interrupt on my board, I can't say it didn't break anything. Maybe
this time again Maxime will be willing to test it.

For the remaining improvement related to the PWA and MMP #ifdef, I
hope to be able to work on it this week-end.

Regards

Gregory CLEMENT (1):
  gpio: pca953x: use simple irqdomain

Linus Walleij (1):
  gpio: pca953x: use managed resources

 drivers/gpio/gpio-pca953x.c |   97 ++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 61 deletions(-)

-- 
1.7.9.5

