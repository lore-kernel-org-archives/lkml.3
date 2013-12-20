Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3LTCue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:50:34 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50745 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3LTCuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:50:32 -0500
MIME-Version: 1.0
Date: Fri, 20 Dec 2013 10:50:30 +0800
Message-ID: <CAPgLHd8bi1rcqSx1YpCVLVmmv8jt97Hh7nvSsqc03YfGh7Jorw@mail.gmail.com>
Subject: [PATCH -next] mfd: rtsx: fix sparse non static symbol warning
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org, micky_ching@realsil.com.cn
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/mfd/rtl8411.c:473:6: warning:
 symbol 'rtl8411_init_common_params' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/rtl8411.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
index ada38ad..fdd34c8 100644
--- a/drivers/mfd/rtl8411.c
+++ b/drivers/mfd/rtl8411.c
@@ -470,7 +470,7 @@ static const u32 rtl8411b_qfn48_ms_pull_ctl_disable_tbl[] = {
 	0,
 };
 
-void rtl8411_init_common_params(struct rtsx_pcr *pcr)
+static void rtl8411_init_common_params(struct rtsx_pcr *pcr)
 {
 	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
 	pcr->num_slots = 2;

