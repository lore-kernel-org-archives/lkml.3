Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaGCUSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:18:06 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38692 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaGCUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:18:03 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3] i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereferenc  
Date: Thu,  3 Jul 2014 22:19:15 +0200
Message-Id: <1404418756-10550-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussion with especially Wolfram and Jingoo it was decided to convert the code to use the Managed Device Resource.
I lack this kind of hardware so preferably should someone do a HW test.

Rickard Strandqvist (1):
  i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereferenc

 drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

-- 
1.7.10.4

