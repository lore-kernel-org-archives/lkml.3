Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3BLUfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3BLUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 05/61] regulator: s2mps11: fix incorrect register for buck10
Date: Tue, 12 Feb 2013 12:34:25 -0800
Message-Id: <20130212203418.789942388@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alim Akhtar <alim.akhtar@samsung.com>

commit c76edd52bf19c9d01da7edc4ff04d3707c299779 upstream.

For BUCK10 the control registers are wrongly set as buck9 control register
This patch corrects the control registers for buck10

Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/s2mps11.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -174,9 +174,9 @@ static struct regulator_ops s2mps11_buck
 	.min_uV		= S2MPS11_BUCK_MIN2,			\
 	.uV_step	= S2MPS11_BUCK_STEP2,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
-	.vsel_reg	= S2MPS11_REG_B9CTRL2,			\
+	.vsel_reg	= S2MPS11_REG_B10CTRL2,			\
 	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
-	.enable_reg	= S2MPS11_REG_B9CTRL1,			\
+	.enable_reg	= S2MPS11_REG_B10CTRL1,			\
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 


