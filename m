Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaGPVND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:13:03 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34036 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbaGPVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:12:53 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v4] i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereference  
Date: Wed, 16 Jul 2014 23:14:10 +0200
Message-Id: <1405545251-13087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This start as a fix for possible null pointer dereference.
But after discussion with especially Wolfram, Jingoo and Emil it was
decided to convert the code to uses Managed Device Resource instead.

Rickard Strandqvist (1):
  i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereference

 drivers/i2c/busses/i2c-pxa.c |   65 ++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 43 deletions(-)

-- 
1.7.10.4

