Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaF2X12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 19:27:28 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43471 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaF2X10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 19:27:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2] i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereferenc  
Date: Mon, 30 Jun 2014 01:28:35 +0200
Message-Id: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discussion with especially Wolfram it was decided to convert the code to use the Managed Device Resource.
I have now tried to create a patch with Devres, hope it is correct.
But a code review is probably more relevant than usual.
I also lack this kind of hardware so preferably should someone do a HW test.

Rickard Strandqvist (1):
  i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereferenc

 drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

-- 
1.7.10.4

