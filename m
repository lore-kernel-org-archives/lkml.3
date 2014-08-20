Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaHTNn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:43:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40194 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaHTNnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:23 -0400
X-AuditID: cbfee61b-f79f86d00000144c-1f-53f4a5f8330b
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/3] LED / flash API integration - V4L2 Flash
Date: Wed, 20 Aug 2014 15:43:08 +0200
Message-id: <1408542191-335-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t9jAd0fS78EGyx7y2exccZ6Vov5R86x
	WvRefc5ocbbpDbvF5V1z2Cy2vlnHaNGzYSurA7tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVw
	ZZy8PoGp4C1Xxbd9vawNjHM5uhg5OSQETCTOvFjCBGGLSVy4t56ti5GLQ0hgEaPEnX+9TBBO
	O5NEx8UHjCBVbAKGEj9fvAbrEBEol+h5/4wNxGYWSJNYs/4+WI2wgIvEre0bWEBsFgFViVvH
	3oLV8wq4SWztaQOq5wDapiAxZ5LNBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGC
	w+CZ9A7GVQ0WhxgFOBiVeHhvLPoSLMSaWFZcmXuIUYKDWUmEt70TKMSbklhZlVqUH19UmpNa
	fIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoHRO3SDwzH7x0v6b3w4XPXz8Te+ycpv
	3j5+w2by15xf7P6J4/8DK9Zwr197gUFs5muDlpd8swWrosJjZm8Q9jxkJ6zatqvq5yel1Xul
	OkPen+lU9jiwYsmk3fs3vz+yavEXd1HFRauv7m3ceOnwUqUfK23ei3jcPVL26fO/rK1p6/WW
	+7UsnPyqw0iJpTgj0VCLuag4EQCySsYg/wEAAA==
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
  v4l2-ctrls: add control for flash strobe signal providers
  media: Add registration helpers for V4L2 flash
  exynos4-is: Add support for v4l2-flash subdevs

 Documentation/DocBook/media/v4l/controls.xml  |   11 +
 drivers/leds/led-class-flash.c                |   25 ++
 drivers/media/platform/exynos4-is/media-dev.c |   37 +-
 drivers/media/platform/exynos4-is/media-dev.h |   13 +-
 drivers/media/v4l2-core/Kconfig               |   11 +
 drivers/media/v4l2-core/Makefile              |    2 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |    2 +
 drivers/media/v4l2-core/v4l2-flash.c          |  577 +++++++++++++++++++++++++
 include/linux/led-class-flash.h               |   11 +
 include/media/v4l2-flash.h                    |  121 ++++++
 include/uapi/linux/v4l2-controls.h            |    2 +
 11 files changed, 809 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

