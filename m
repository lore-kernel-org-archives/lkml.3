Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbaJVL5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:57:37 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35203 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaJVL5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:57:35 -0400
From: Zhou Wang <wangzhou.bry@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Wei Xu <xuwei5@hisilicon.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
        Zhou Wang <wangzhou.bry@gmail.com>
Subject: [PATCH v1 0/2] ARM: hip04: add GPIO support
Date: Wed, 22 Oct 2014 19:55:58 +0800
Message-Id: <1413978960-10717-1-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the support for the GPIOs of Hisilicon Soc hip04. Hip04 uses
synopsis' GPIO IP, and we use the dwapb GPIO driver here. This series add the
corresponding dts.

As the hip04 basic dts has been merged in 3.18 mainline kernel, I just resend
this patchset for review.

Zhou Wang (2):
  ARM: hip04: set ARCH_NR_GPIO to 128
  ARM: dts: hip04: add GPIO pieces

 arch/arm/Kconfig             |    1 +
 arch/arm/boot/dts/hip04.dtsi |   75 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

-- 
1.7.9.5

