Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaJXXsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:48:25 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56166 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaJXXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:48:23 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org, b02247@freescale.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com
Subject: [PATCH 0/2] ASoC: fsl: Use dynamic slot width for ESAI.
Date: Fri, 24 Oct 2014 16:48:10 -0700
Message-Id: <cover.1414193668.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add the support of dynamic slot width for
ESAI driver. To do this, the PATCH-1 removes the fixed width. In
order not to break those platforms that use fixed width, there
comes the PATCH-2 to apply an override of slot_width.

@Shengjiu,
Will you be available to test this series on Sabre Auto for both
Master and Slave cases? I'd like to wait for your Test-by. Thanks.

Nicolin Chen (2):
  ASoC: fsl_esai: Use dynamic slot width as default
  ASoC: fsl-asoc-card: Add slot_width setting for cpu-dai

 sound/soc/fsl/fsl-asoc-card.c | 12 ++++++++++++
 sound/soc/fsl/fsl_esai.c      | 12 +++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

-- 
1.9.1

