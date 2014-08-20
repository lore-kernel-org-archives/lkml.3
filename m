Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaHTNmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:42:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60618 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaHTNmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:15 -0400
X-AuditID: cbfee61a-f79e46d00000134f-fe-53f4a5b58823
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/4] LED / flash API integration - LED Flash Class
Date: Wed, 20 Aug 2014 15:41:54 +0200
Message-id: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t9jAd2tS78EG5ydqGCxccZ6Vov5R86x
	WvRefc5ocbbpDbvF5V1z2Cy2vlnHaNGzYSurA7tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVw
	Zcxaso+5YBZnxcoLvxkbGCewdzFyckgImEh0z/zPDGGLSVy4t56ti5GLQ0hgEaPExE+bmCGc
	diaJxt8/wDrYBAwlfr54zQRiiwiUS/S8f8YGYjMLpEmsWX+fEcQWFvCUeP+5EayeRUBV4sy8
	2WA1vAIeElcPtwD1cgBtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB
	YfBMagfjygaLQ4wCHIxKPLwNC74EC7EmlhVX5h5ilOBgVhLhbe8ECvGmJFZWpRblxxeV5qQW
	H2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamDcupb//oF7MX1zHzBMmLKi7n+36mS7
	Y0KGh3XusB5bYswlzNO7vlV5z/pe9rMHjbIeGc3qkiqoTBX7frNpyvngq7sbV8RMFNmkOvWd
	/bSEp7PbPAQWfb68OevS1g9ctxR0Ol8U/ElrvT2HYYq/xVTVOTOmXL7S8vY6M1fx+mTGvRy8
	Vi5e9XXJSizFGYmGWsxFxYkAliK79/8BAAA=
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

Jacek Anaszewski (4):
  leds: Improve and export led_update_brightness
  leds: implement sysfs interface locking mechanism
  leds: add API for setting torch brightness
  leds: Add LED Flash Class wrapper to LED subsystem

 drivers/leds/Kconfig            |   11 +
 drivers/leds/Makefile           |    1 +
 drivers/leds/led-class-flash.c  |  645 +++++++++++++++++++++++++++++++++++++++
 drivers/leds/led-class.c        |   40 ++-
 drivers/leds/led-core.c         |   48 +++
 drivers/leds/led-triggers.c     |   20 +-
 include/linux/led-class-flash.h |  273 +++++++++++++++++
 include/linux/leds.h            |   66 ++++
 8 files changed, 1091 insertions(+), 13 deletions(-)
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 include/linux/led-class-flash.h

-- 
1.7.9.5

