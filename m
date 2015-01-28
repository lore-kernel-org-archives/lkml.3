Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451AbbA1CYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:24:34 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38553 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbbA1CYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:24:32 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v2 0/3] AT91 pm improvements for 3.20
Date: Wed, 28 Jan 2015 10:21:47 +0800
Message-ID: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

This patch set is to add the pm support for the ARMv7 SoCs.

It is based on the following patch set,
	[PATCH v4 00/12] AT91 pm cleanup for 3.20

Changes in v2.0
 - Drop patch to enable the l2 cache controller.
 - Remove patches to disable the mpddrc and DDR clock.
 - Remove patch to change to get the memory type.
 - Fix some commments

Patrice Vilchez (1):
  pm: at91: pm_suspend: MOR register KEY was missing

Wenyou Yang (2):
  pm: at91: pm_suspend: add the WFI support for ARMv7
  pm: at91: add disable/enable the L1/L2 cache while suspend/resume

 arch/arm/mach-at91/pm.c         |   12 +++
 arch/arm/mach-at91/pm_suspend.S |  158 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 169 insertions(+), 1 deletion(-)

-- 
1.7.9.5

