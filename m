Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaAKEDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 23:03:46 -0500
Received: from nm13-vm5.bullet.mail.gq1.yahoo.com ([98.136.218.236]:44983 "EHLO
	nm13-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753574AbaAKEDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 23:03:17 -0500
X-Yahoo-Newman-Id: 798953.26252.bm@smtp217.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: u6KVZAUVM1lxZuCXlkn5_bXytcbDDQERheyvePHCTS1wIJk
 YMVYKU.okaD.Orb5ptaxVCF0nJKHjJoftm58GxZNLwIkAWbhEc_ij_W1g9GI
 .yVqEVf_f6LvefyCS8TNZJhj2bFqP.V00gwmHB._NnoFyQ.TXo3yTFcvk23j
 1QL7YDsqrvNGJ87iZ.PjgsCHjG_MrKKQ1fpFLwEcVjmqznfVQE8uswcwDJLm
 S_Ieu3YKzE518MDTEzxHPYmqxb38Vsf45.QbcN7ifO__CVEmYfVrwV0hdbvZ
 GG89DLN3fx1CYRAhp1eZT_lXTGXTuTIgSV4ERqesRMLryFWCelG_960tqtWL
 cS7Tt9DEzRHM5d1U4NyU9Cc_.2ANQrdoJHNCsRGpJPJEelCy0ht2Vr.xWzgw
 6QFQbIl8d4x2svqPKwf6ndaibN4YINkpxMKVNB.RveQSFThVDoU0pWX3OsmX
 goRjzazBA6PjMTjthgfrMjKAfGofc1seO4Z5xdIpKw6MlMcqExiGh2Wkm17U
 NURsYGlgALTiJiw9pyS6uWFou35jtVZ0mv1.XlvFm21KmDdFxcGUGTX9ozQ_
 LmgqRisnakkFPViOmgw7bSe80DeCaVMyKIkzw3IwtFWwWFJ0ED_hiqQ--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.103.236.80 with plain [98.138.105.21])
        by smtp217.mail.gq1.yahoo.com with SMTP; 11 Jan 2014 04:03:16 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH 3/3] Staging: comedi: fix extra whitespace style issues in ni_mio_common.c.
Date: Fri, 10 Jan 2014 22:03:12 -0600
Message-Id: <1389412992-20700-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for ni_mio_common.c removes extra whitespace causing
checkpatch.pl warnings.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/ni_mio_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 95f4e37..457b884 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -992,7 +992,7 @@ static void ack_a_interrupt(struct comedi_device *dev, unsigned short a_status)
 		ack |= AI_START_Interrupt_Ack;
 	if (a_status & AI_STOP_St)
 		/* not sure why we used to ack the START here also, instead of doing it independently. Frank Hess 2007-07-06 */
-		ack |= AI_STOP_Interrupt_Ack /*| AI_START_Interrupt_Ack */ ;
+		ack |= AI_STOP_Interrupt_Ack /*| AI_START_Interrupt_Ack */;
 	if (ack)
 		devpriv->stc_writew(dev, ack, Interrupt_A_Ack_Register);
 }
@@ -4262,7 +4262,7 @@ static int ni_E_init(struct comedi_device *dev)
 	s->n_chan = board->num_p0_dio_channels;
 	if (board->reg_type & ni_reg_m_series_mask) {
 		s->subdev_flags |=
-		    SDF_LSAMPL | SDF_CMD_WRITE /* | SDF_CMD_READ */ ;
+		    SDF_LSAMPL | SDF_CMD_WRITE /* | SDF_CMD_READ */;
 		s->insn_bits = &ni_m_series_dio_insn_bits;
 		s->insn_config = &ni_m_series_dio_insn_config;
 		s->do_cmd = &ni_cdio_cmd;
@@ -4731,7 +4731,7 @@ static int pack_ad8842(int addr, int val, int *bitstring);
 struct caldac_struct {
 	int n_chans;
 	int n_bits;
-	int (*packbits) (int, int, int *);
+	int (*packbits)(int, int, int *);
 };
 
 static struct caldac_struct caldacs[] = {
-- 
1.8.4.2

