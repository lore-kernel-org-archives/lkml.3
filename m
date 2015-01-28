Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbbA1U2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:28:51 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51785 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbbA1U2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:28:44 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 0/2] mmc: pwrseq: Add support to multiple gpios in pwrseq simple
Date: Wed, 28 Jan 2015 13:16:21 +0000
Message-Id: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support to reset/powerup multiple gpio pins on a given
sdio bus. The use case is simple, on sdio we could have multiple devices
like WLAN, BT which are controlled by there own reset lines. So having
multiple reset is something more useful in such cases.

Without this patch I could not get BT and WLAN working at same time on IFC6410.

Thanks,
srini

Srinivas Kandagatla (2):
  mmc: pwrseq: Add support to control multiple gpios in simple pwrseq
  mmc: pwrseq: Update document with multiple gpios support

 .../devicetree/bindings/mmc/mmc-pwrseq-simple.txt  |  7 ++-
 drivers/mmc/core/pwrseq_simple.c                   | 64 +++++++++++++++-------
 2 files changed, 49 insertions(+), 22 deletions(-)

-- 
1.9.1

