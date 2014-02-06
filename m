Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaBFIO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:14:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55703 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaBFIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:14:22 -0500
X-AuditID: cbfee68e-b7f566d000002344-8a-52f3445b9163
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 00/12] backlight: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:14:18 +0900
Message-id: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t8zA91ol89BBscPCFrMWb+GzeLywkus
	Fpd3zWFzYPY4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlTPu9h63gMk/Fxhez2RoY
	/3B2MXJySAiYSDR+62OHsMUkLtxbz9bFyMUhJLCMUeL6uyUsMEXf962DSkxnlPjxcwsrSEJI
	4BejxPerbCA2m4CaxJcvh4EmcXCICOhLtLVogJjMAi4SR6eJgFQICzhK7D70GKyCRUBVYv5h
	fpAwr4CtxLeW24wQtqDEj8n3wLYyC2hJrN95nAnClpfYvOYtM0irhIC6xKO/uiBhEQE9iW8L
	D0CViEjse/GOEeLgVewSL34GgdgsAgIS3yYfYoFolZXYdIAZokRS4uCKGywTGMVmIVk8C8ni
	WUgWz0KyYQEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkEjq28F484D1IcZkoPUTmaVE
	k/OBkZhXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhhXrSsV2v7/2u73YjP/8xz9udn/7+oXn95c2Bvon27VZfH5Spik9JLfC1e4OR2P9wmdvNbG
	MyHXS+mA9ZyLvRu2iSjHVnSdvuDgsc7UMWPhe64j8Vo7dA3Kb0qxmvCKN8ZvCjxYOylP1EHq
	yZlNDM9Le1fuX8PwQyJnl7BOgPMShmyVVCmFh05KLMUZiYZazEXFiQBxNxImugIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoG60y+cgg42neC3mrF/DZnF54SVW
	i8u75rA5MHucmPGbxaNvyypGj8+b5AKYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCesYM6b93sNWcJmnYuOL2WwNjH84uxg5OSQETCS+71vHBmGLSVy4tx7I5uIQEpjOKPHj
	5xZWkISQwC9Gie9XwYrYBNQkvnw5zN7FyMEhIqAv0daiAWIyC7hIHJ0mAlIhLOAosfvQY7AK
	FgFVifmH+UHCvAK2Et9abjNC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhmkVUJAXeLRX12Q
	sIiAnsS3hQegSkQk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIER+oz6R2MqxosDjEKcDAq8fBuWP8pSIg1say4MvcQowQHs5II71bzz0FCvCmJ
	lVWpRfnxRaU5qcWHGJOB/pzILCWanA9MInkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwKh+/nd057LvO7PVXDRLglZWBx+byLC+XqFwyX21a3f4l3+zmnm6
	cMa5hKez36zee++kMe/hVVeV7p4+9SLtjf3Exyvrv08//HpO4tlS9X97miRm/H/2p8iBdVuL
	nHjPFs41rfXZF852cCXyuNzy/3v8BO/VuQskq4ynHlrj5mKZZ7HgjEPVx/l3lFiKMxINtZiL
	ihMBpfIDyBgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message. For example,
k.alloc and v.alloc failures use dump_stack().

Jingoo Han (12):
      backlight: aat2870: Remove unnecessary OOM messages
      backlight: adp8860: Remove unnecessary OOM messages
      backlight: adp8870: Remove unnecessary OOM messages
      backlight: corgi_lcd: Remove unnecessary OOM messages
      backlight: hx8357: Remove unnecessary OOM messages
      backlight: ili922x: Remove unnecessary OOM messages
      backlight: ili9320: Remove unnecessary OOM messages
      backlight: l4f00242t03: Remove unnecessary OOM messages
      backlight: lm3533_bl: Remove unnecessary OOM messages
      backlight: lms283gf05: Remove unnecessary OOM messages
      backlight: platform_lcd: Remove unnecessary OOM messages
      backlight: tps65217_bl: Remove unnecessary OOM messages
---
 drivers/video/backlight/aat2870_bl.c   |    2 --
 drivers/video/backlight/adp8860_bl.c   |    4 +---
 drivers/video/backlight/adp8870_bl.c   |    4 +---
 drivers/video/backlight/corgi_lcd.c    |    4 +---
 drivers/video/backlight/hx8357.c       |    4 +---
 drivers/video/backlight/ili922x.c      |    4 +---
 drivers/video/backlight/ili9320.c      |    4 +---
 drivers/video/backlight/l4f00242t03.c  |    5 +----
 drivers/video/backlight/lm3533_bl.c    |    5 +----
 drivers/video/backlight/lms283gf05.c   |    4 +---
 drivers/video/backlight/platform_lcd.c |    4 +---
 drivers/video/backlight/tps65217_bl.c  |    5 +----
 12 files changed, 11 insertions(+), 38 deletions(-)


