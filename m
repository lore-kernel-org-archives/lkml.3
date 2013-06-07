Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3FGPpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:45:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50149 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab3FGPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:45:19 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] i2c-mv64xxx: Various fixes
Date: Fri,  7 Jun 2013 17:44:58 +0200
Message-Id: <1370619900-15963-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series contains a real fix for the I2C controller of the Armada
XP SoC and a patch closer to a improvement than a fix.

They are independent and are only in the same series because they are
kind of fixes.

They are based on 3.10-rc4, and they will be small conflicts if they
are applied on top of i2c/for-next branch and on top of the series I
have just sent to add I2C Transaction Generator support. You can have
a look on the branch i2c-mv64xxx-fixes-bridge to get an idea on how to
resolve it. This branch is located at
https://github.com/MISL-EBU-System-SW/mainline-public.git

Thanks,

Zbigniew Bodek (2):
  i2c-mv64xxx: Fix timing issue on Armada XP (errata FE-8471889)
  i2c-mv64xxx: Abort the mv64xxx_of_config if clock-frequency is not
    provided

 drivers/i2c/busses/i2c-mv64xxx.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

-- 
1.8.1.2

