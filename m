Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3FKUFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:05:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3FKUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 69/79] iio: frequency: ad4350: Fix bug / typo in mask
Date: Tue, 11 Jun 2013 13:03:35 -0700
Message-Id: <20130611195325.104610331@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 2eb3a81eef0510511a3211bb3da560f446a8c8de upstream.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/frequency/adf4350.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/frequency/adf4350.c
+++ b/drivers/iio/frequency/adf4350.c
@@ -212,7 +212,7 @@ static int adf4350_set_freq(struct adf43
 		(pdata->r2_user_settings & (ADF4350_REG2_PD_POLARITY_POS |
 		ADF4350_REG2_LDP_6ns | ADF4350_REG2_LDF_INT_N |
 		ADF4350_REG2_CHARGE_PUMP_CURR_uA(5000) |
-		ADF4350_REG2_MUXOUT(0x7) | ADF4350_REG2_NOISE_MODE(0x9)));
+		ADF4350_REG2_MUXOUT(0x7) | ADF4350_REG2_NOISE_MODE(0x3)));
 
 	st->regs[ADF4350_REG3] = pdata->r3_user_settings &
 				 (ADF4350_REG3_12BIT_CLKDIV(0xFFF) |


