Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaHVUIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:08:40 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52253 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaHVUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:08:26 -0400
From: Marco Cyriacks <marco@cyriacks.net>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Marco Cyriacks <marco@cyriacks.net>
Subject: [PATCH] socklnd: Code style fix (eudyptula challenge task 10)
Date: Fri, 22 Aug 2014 22:08:05 +0200
Message-Id: <1408738086-19854-1-git-send-email-marco@cyriacks.net>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:fXRPfBzgB5AXpsnKC6Adqcfr6sRBwqfz2QEucjpiWP2
 cdHqyZ7qQj4r2xMKR64joTz7U/y2iA7XCWd7cGH83y+H4EhV7L
 jJgmJeLJXSJREsFG9Ak/4Av8cmtlyll0wz/PFMDCsKf+hY716y
 TGjx2C5duJndr+1y0mdFmOQ+OkqkBpYJujrEXqpy3zAPQPl/4r
 IoKezgATW5xPa/iAkIMfZ2PjBIDuYKahuHdpsyPRKYTCC0to68
 sfhPLOTQHoGxyzHUVcn3h4TwRRkqQGK/lzdBbD5UZxgKF5qLVt
 qY323UujjfBiHuRyaHUCTqP2Ye1YNYaMTWTJtcOQDzPslQLTRz
 nLFWq39vfHO6/oc1qDoi/CsZ6ks2GN3+bUYjNXQSJZBuXpsm9a
 h6XSYu/gw6HPQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently working on the eudyptula challenge and this is my first
"kernel contribution" to pass task 10 of the challenge.

The task was to fix one coding style error of a file in the drivers
staging area.

This patch was prepared on top of next-20140822. Please consider it
for inclusion.


Best regards,
Marco

Marco Cyriacks (1):
  socklnd: Remove static initialization to NULL or 0

 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_modparams.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
1.9.3

