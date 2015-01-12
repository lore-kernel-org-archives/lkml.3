Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbALQht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:37:49 -0500
Received: from [84.20.150.21] ([84.20.150.21]:38178 "EHLO fixme.fi"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbbALQhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:37:48 -0500
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 11:37:47 EST
From: Tero Marttila <tero.marttila@aalto.fi>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Luis de Bethencourt <luis@debethencourt.com>,
        Tero Marttila <tero.marttila@aalto.fi>
Subject: [PATCH] staging: octeon: Fix checkpatch line spacing warnings
Date: Mon, 12 Jan 2015 18:27:38 +0200
Message-Id: <1421080058-8871-1-git-send-email-tero.marttila@aalto.fi>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing blank lines after declarations in octeon/ethernet-rx.c

Signed-off-by: Tero Marttila <tero.marttila@aalto.fi>
---
 drivers/staging/octeon/ethernet-rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index fcbe836..22667db 100644
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
@@ -214,6 +215,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 		did_work_request = 0;
 		if (work == NULL) {
 			union cvmx_pow_wq_int wq_int;
+
 			wq_int.u64 = 0;
 			wq_int.s.iq_dis = 1 << pow_receive_group;
 			wq_int.s.wq_int = 1 << pow_receive_group;
-- 
1.9.1

