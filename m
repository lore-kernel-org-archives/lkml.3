Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaHTNm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:42:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40175 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaHTNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:54 -0400
X-AuditID: cbfee61b-f79f86d00000144c-fd-53f4a5dcd6b6
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 0/2] LED / flash API integration - Flash Manager
Date: Wed, 20 Aug 2014 15:42:41 +0200
Message-id: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t9jQd07S78EGyzZq2WxccZ6Vov5R86x
	WvRefc5ocbbpDbvF5V1z2Cy2vlnHaNGzYSurA7tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVw
	Zexr2MRUcI27ouvFI8YGxjbOLkZODgkBE4kZ884wQdhiEhfurWcDsYUEpjNKPJyk3sXIBWS3
	M0kcfvqCHSTBJmAo8fPFa7AGEYFyiZ73z8AamAXSJNasv88IYgsLuEvsfnEVLM4ioCpxbFIj
	WJxXwEPiytLnQHEOoGUKEnMm2Uxg5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgI
	nknvYFzVYHGIUYCDUYmH98aiL8FCrIllxZW5hxglOJiVRHjbO4FCvCmJlVWpRfnxRaU5qcWH
	GKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGCWWfFrLp1cksPlcT90mrnls563iU0Ik
	e9zfGp57J67+mFX69rS245aigi9+nCgr1Xozo1KrpXLywq9TvRfH/oh6Xz5tpub5n6uP5RW5
	Tbiy4dCUuWdqW96tzwhc++nMM2NG08INnw6Ur0i8F7xnyheduNfZUy1XFYcZ1TcJ1ThGt6wP
	5chsWKXEUpyRaKjFXFScCAAXWove/gEAAA==
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

Jacek Anaszewski (2):
  of: add of_node_ncmp wrapper
  leds: Add Flash Manager functionality

 arch/sparc/include/asm/prom.h        |    1 +
 drivers/leds/Kconfig                 |   11 +
 drivers/leds/Makefile                |    4 +
 drivers/leds/led-class-flash.c       |   19 ++
 drivers/leds/led-flash-gpio-mux.c    |  102 ++++++
 drivers/leds/led-flash-manager.c     |  590 ++++++++++++++++++++++++++++++++++
 drivers/leds/of_led_flash_manager.c  |  155 +++++++++
 include/linux/led-flash-gpio-mux.h   |   68 ++++
 include/linux/led-flash-manager.h    |  146 +++++++++
 include/linux/leds.h                 |    1 +
 include/linux/of.h                   |    1 +
 include/linux/of_led_flash_manager.h |   80 +++++
 12 files changed, 1178 insertions(+)
 create mode 100644 drivers/leds/led-flash-gpio-mux.c
 create mode 100644 drivers/leds/led-flash-manager.c
 create mode 100644 drivers/leds/of_led_flash_manager.c
 create mode 100644 include/linux/led-flash-gpio-mux.h
 create mode 100644 include/linux/led-flash-manager.h
 create mode 100644 include/linux/of_led_flash_manager.h

-- 
1.7.9.5

