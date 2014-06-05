Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaFEUsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:48:45 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49153 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFEUsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:48:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Henk de Groot <pe1dnn@amsat.org>, Jarod Wilson <jarod@wilsonet.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/5] randconfig build fixes for staging
Date: Thu,  5 Jun 2014 22:48:10 +0200
Message-Id: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:R1AQya4hmsoWkl3KSnTfa1l5bNPBuV+2G7xQv4RwoTk
 uqsqcP3slpNeIL19pj1ACkzOQ3MrCXVbVJc0TpZ6DxUoa/RIok
 aKyjjkk4Wnpc8NSYcMbfmcuz1nlm4W/PnRL69tJscJrFXrDdvD
 AKExc1zRB5OFctLeVvYeqGEtjVTFHubN/ZMKimhTAA2A3rQlel
 o50wRpf9Pi2W9eCKHDL55//jukUiKEmr4lh0odU8LB3MoQ4G5q
 s+n4smDGNhVwnfdXZ+3DuTaVqH8IQpSnjmmehe8WJ7hMu3cxRx
 CTef6hrsh/0DmHMxsZuywgNuCz82VwX4ZLAkXHEcCMoyDPpJIY
 205AM2MPbeb8KELpduBVOInjVnQc+AyDTFH+FVIGi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here are a couple of simple fixes from my backlog of ARM
randconfig bugs. Nothing urgent, they can probably all go
into next for 3.17 after the merge window, but see for
yourself.

	Arnd

Arnd Bergmann (5):
  staging: lirc: remove sa1100 support
  staging/iio: IIO_SIMPLE_DUMMY_BUFFER neds IIO_BUFFER
  staging: sn9c102 depends on USB
  staging: wlags49_h2: avoid PROFILE_ALL_BRANCHES warnings
  staging: rtl8712, rtl8712: avoid lots of build warnings

 drivers/staging/iio/Kconfig                    |   9 +-
 drivers/staging/media/lirc/lirc_sir.c          | 301 +------------------------
 drivers/staging/media/sn9c102/Kconfig          |   2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h |  10 +-
 drivers/staging/rtl8712/ieee80211.h            |   4 +-
 drivers/staging/wlags49_h2/wl_internal.h       |   4 +-
 6 files changed, 17 insertions(+), 313 deletions(-)

-- 
1.8.3.2

Cc: Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Henk de Groot <pe1dnn@amsat.org>
Cc: Jarod Wilson <jarod@wilsonet.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: linux-iio@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org
