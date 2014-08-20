Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaHTNoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36197 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaHTNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:56 -0400
X-AuditID: cbfee61b-f79f86d00000144c-63-53f4a61a32ed
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/3] LED / flash API integration - LED Flash Class
 drivers
Date: Wed, 20 Aug 2014 15:43:38 +0200
Message-id: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t9jQV2pZV+CDe6sNbTYOGM9q8X8I+dY
	LXqvPme0ONv0ht3i8q45bBZb36xjtOjZsJXVgd2jb8sqRo/Pm+QCmKK4bFJSczLLUov07RK4
	MvacUSs4wFEx5fpjtgbGrWxdjBwcEgImElebErsYOYFMMYkL99YDhbk4hASmM0q8+LWSHSQh
	JNDOJNHT5QZiswkYSvx88ZoJxBYRKJfoef+MDcRmFkiTWLP+PiOILSwQLLGsdTpYnEVAVeLP
	lAZWEJtXwE2i889VVoi9ChJzJtlMYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	AJ5J72Bc1WBxiFGAg1GJh/fGoi/BQqyJZcWVuYcYJTiYlUR42zuBQrwpiZVVqUX58UWlOanF
	hxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhhZAtstgxauyqv5cPxt1uP7VwPal8wT
	eMRRE1tp0akVwGAi9vdPadGSLf4nPm272p0+o3lrhfb3Z0ezgq8mCr0tXHxHcsmmxOyGiSbb
	pM6/W2zQ7C24deXRM8azfPvnx6VP47mk9fD3ztcTlpnc/x8y31BJQa/p6ykXg8h1jf1zpD9N
	jvXUuMqkxFKckWioxVxUnAgAxgqZcfwBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is the follow-up of the LED / flash API integration
series [1]. For clarity reasons the patchset has been split into
five subsets:

- LED Flash Class
- Flash Manager
- V4L2 Flash
- LED Flash Class drivers
- Documentation

The series is based on linux-next-20140820.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2014/7/11/914

Jacek Anaszewski (3):
  mfd: max77693: Fix register enum name
  leds: Add support for max77693 mfd flash cell
  leds: Add driver for AAT1290 current regulator

 drivers/leds/Kconfig                 |   15 +
 drivers/leds/Makefile                |    2 +
 drivers/leds/leds-aat1290.c          |  448 +++++++++++++++
 drivers/leds/leds-max77693.c         | 1048 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |    5 +-
 include/linux/mfd/max77693-private.h |   61 +-
 include/linux/mfd/max77693.h         |   40 ++
 7 files changed, 1617 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c

-- 
1.7.9.5

