Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaFFMpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:45:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56422 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaFFMpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:45:10 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [GIT PULL] SH Driver Updates for v3.16
Date: Fri,  6 Jun 2014 21:44:31 +0900
Message-Id: <cover.1402058435.git.horms+renesas@verge.net.au>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider these SH Driver Updates for v3.16

This pull request is based on the SH Driver Updates for v3.15,
tagged as sh-drivers-for-v3.15, which you included in v3.15-rc6.


The following changes since commit 3c90c55dcde745bed81f6447f24ba96bda43d984:

  drivers: sh: compile drivers/sh/pm_runtime.c if ARCH_SHMOBILE_MULTI (2014-05-12 16:05:01 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git tags/renesas-sh-drivers-for-v3.16

for you to fetch changes up to 2f35fb3c8a6018a0a5fe4a7fb0948b853c157256:

  drivers: sh: Enable PM runtime for new R-Car Gen2 SoCs (2014-06-05 09:50:11 +0900)

----------------------------------------------------------------
SH Driver Update for v3.16

* PM Runtime enhancements targeted for use with
  ARM-based Renesas R-Car Gen2 SoCs
* Restrict INTC_USERIMASK to SH4A as it is only used there

----------------------------------------------------------------
Ben Dooks (2):
      drivers: sh: pm_runtime does not need idle callback
      drivers: sh: pm_runtime implementation needs to suspend and resume devices

Geert Uytterhoeven (2):
      drivers: sh: Restrict INTC_USERIMASK to SH4A
      drivers: sh: Enable PM runtime for new R-Car Gen2 SoCs

 drivers/sh/intc/Kconfig |  2 +-
 drivers/sh/pm_runtime.c | 40 ++++++++++++++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 7 deletions(-)
