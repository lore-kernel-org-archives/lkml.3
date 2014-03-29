Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaC2RtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:49:19 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64057 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaC2RtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:49:17 -0400
Date: Sat, 29 Mar 2014 23:19:43 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 07/55] scsi: Mark function as static in bfa/bfa_fcs_lport.c
Message-ID: <3f40c168fa91d426705cacbb288949c4447c6d72.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in bfa/bfa_fcs_lport.c because it is not used
outside this file.

This eliminates the following warning in bfa/bfa_fcs_lport.c:
drivers/scsi/bfa/bfa_fcs_lport.c:1283:1: warning: no previous prototype for ‘bfa_fcport_get_loop_attr’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..0515b01 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1279,7 +1279,7 @@ bfa_fcs_lport_n2n_offline(struct bfa_fcs_lport_s *port)
 	n2n_port->reply_oxid = 0;
 }
 
-void
+static void
 bfa_fcport_get_loop_attr(struct bfa_fcs_lport_s *port)
 {
 	int i = 0, j = 0, bit = 0, alpa_bit = 0;
-- 
1.7.9.5

