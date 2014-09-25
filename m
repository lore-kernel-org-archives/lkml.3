Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaIYGcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:32:20 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35744 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYGcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:32:18 -0400
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mfd: tps65217: adds support for compatible string of subdevices
Date: Thu, 25 Sep 2014 08:31:37 +0200
Message-ID: <3630485.2UAvhovk8D@lenovobook>
User-Agent: KMail/4.14 (Linux/3.16.3-1-ARCH; KDE/4.14.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the of_compatible string for the subdevices of the tps65217.

The TPS65217 is missing of_compatible string in the mfd_cell for its
subdevices. This compatible string is necessary to use functions like
of_find_backlight_by_node in backlight.c.

Change since v1:
1. Clarified new compatible string is for sub-node
2. Split the patch 

Johannes Pointner (2):
  mfd: tps65217: add compatible string for subdevices
  dt: bindings: tps65217: add compatible property for subnodes

 Documentation/devicetree/bindings/regulator/tps65217.txt         | 7 ++++++-
 .../devicetree/bindings/video/backlight/tps65217-backlight.txt   | 9 ++++++---
 drivers/mfd/tps65217.c                                           | 2 ++
 3 files changed, 14 insertions(+), 4 deletions(-)

-- 
2.1.0
