Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaHTNsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:48:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60798 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaHTNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:29 -0400
X-AuditID: cbfee61b-f79f86d00000144c-9b-53f4a63ba98c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v5 00/10] LED / flash API integration - documentation
Date: Wed, 20 Aug 2014 15:44:09 +0200
Message-id: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t9jAV3rZV+CDc7cMbHYOGM9q8X8I+dY
	LXqvPme0ONv0ht3i8q45bBZb36xjtOjZsJXVgd2jb8sqRo/Pm+QCmKK4bFJSczLLUov07RK4
	Mu4udy94ylfx5s5WlgbGn9xdjJwcEgImEs2TLrFA2GISF+6tZwOxhQQWMUoc2m7WxcgFZLcz
	SXTu/wpWxCZgKPHzxWsmEFtEoFyi5/0zsAZmgTSJNevvM4LYwgKeEm9uLgOrYRFQldgxaS5z
	FyMHB6+Am0T3MmUQU0JAQWLOJJsJjNwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH
	wDPpHYyrGiwOMQpwMCrx8N5Y9CVYiDWxrLgy9xCjBAezkghveydQiDclsbIqtSg/vqg0J7X4
	EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2NabxV7mrnFJi31uxZ/f7DwOJolNq85
	kTfH4WvBu0D+GTfkG/Pa/moev2UuwjLlcfzLyQb/H3ge4vuXczSiLq3s464socublObd2HyI
	LXHKvTmmyfevJzVv2vOTnaXjwqnmS3JK7F39OzMyTYunsGxoejLhf/R5Ll3xf5/fT757SVa5
	qfwNM7cSS3FGoqEWc1FxIgCxrJOy/AEAAA==
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

Jacek Anaszewski (10):
  Documentation: leds: Add description of LED Flash Class extension
  Documentation: leds: Add description of Flash Manager
  Documentation: leds: add exemplary asynchronous mux driver
  DT: leds: Add flash led devices related properties
  DT: Add documentation for LED Class Flash Manger
  DT: Add documentation for exynos4-is 'flashes' property
  DT: Add documentation for the mfd Maxim max77693
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290
  ARM: dts: add aat1290 current regulator device node

 Documentation/devicetree/bindings/leds/common.txt  |   16 ++
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 ++
 .../bindings/leds/leds-flash-manager.txt           |  163 ++++++++++++++++++++
 .../devicetree/bindings/media/samsung-fimc.txt     |    5 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   62 ++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-async-mux.c                |   65 ++++++++
 Documentation/leds/leds-class-flash.txt            |  118 ++++++++++++++
 arch/arm/boot/dts/exynos4412-trats2.dts            |   24 +++
 9 files changed, 471 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 Documentation/devicetree/bindings/leds/leds-flash-manager.txt
 create mode 100644 Documentation/leds/leds-async-mux.c
 create mode 100644 Documentation/leds/leds-class-flash.txt

-- 
1.7.9.5

