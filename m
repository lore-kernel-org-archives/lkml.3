Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaLCWfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:35:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45804 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaLCWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:35:07 -0500
From: Jamie Lawler <jamie.lawler@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: octeon: Added blank lines after declarations
Date: Wed,  3 Dec 2014 22:35:03 +0000
Message-Id: <1417646103-2486-1-git-send-email-jamie.lawler@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
There are 2 missing blank lines after declarations in
octeon/ethernet-rx.c. I have added them per the coding style.

Regards,
Jamie Lawler

Signed-off-by: Jamie Lawler <jamie.lawler@gmail.com>
---
 drivers/staging/octeon/ethernet-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 1789a12..cecb806 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -109,6 +109,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
 		int interface = cvmx_helper_get_interface_num(work->ipprt);
 		int index = cvmx_helper_get_interface_index_num(work->ipprt);
 		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
+
 		gmxx_rxx_frm_ctl.u64 =
 		    cvmx_read_csr(CVMX_GMXX_RXX_FRM_CTL(index, interface));
 		if (gmxx_rxx_frm_ctl.s.pre_chk == 0) {
@@ -212,6 +213,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		did_work_request = 0;
 		if (work == NULL) {
 			union cvmx_pow_wq_int wq_int;
+
 			wq_int.u64 = 0;
 			wq_int.s.iq_dis = 1 << pow_receive_group;
 			wq_int.s.wq_int = 1 << pow_receive_group;
-- 
2.1.0

