Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaISL0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:26:42 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51197 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbaISL0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:26:40 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH v2] Enable ADC support for Colibri VF61 modules
Date: Fri, 19 Sep 2014 16:56:12 +0530
Message-Id: <cover.1411122224.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
Sorted the nodes alphabetically

Initial discussion over here
[1]: https://lkml.org/lkml/2014/9/19/145

Sanchayan Maity (1):
  ARM: dts: vf610-colibri: Add ADC support

 arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
1.7.9.5

