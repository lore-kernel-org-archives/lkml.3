Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaFWSNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:13:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48592 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaFWSNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:13:05 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1403546409-10860-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Mon, 23 Jun 2014 13:12:58 -0500
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org,
        Sujit Reddy Thumma <sthumma@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C77397FA-1247-4D99-A0AC-9EFE45F7036E@codeaurora.org>
References: <1403546409-10860-1-git-send-email-srinivas.kandagatla@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 23, 2014, at 1:00 PM, Srinivas Kandagatla <srinivas.kandagatla@linaro.org> wrote:

> Add a PHY driver for uses with AHCI based SATA controller driver on the
> APQ8064 family of SoCs.
> 
> This patch is a forward port plus separating PHY code of SATA driver
> from Qualcomm's v3.4 andriod kernel.
> 
> Tested on IFC6410 board.
> 
> CC: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
> drivers/phy/Kconfig                 |   7 +
> drivers/phy/Makefile                |   1 +
> drivers/phy/phy-qcom-apq8064-sata.c | 358 ++++++++++++++++++++++++++++++++++++
> 3 files changed, 366 insertions(+)
> create mode 100644 drivers/phy/phy-qcom-apq8064-sata.c

Did you look at the 3.10 Android kernel tree version of the phy driver?

Also do you have a DT binding spec to go with this?

- k