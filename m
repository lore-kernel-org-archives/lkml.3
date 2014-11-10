Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaKJRdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:33:46 -0500
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:19937
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753490AbaKJRdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:33:44 -0500
X-Greylist: delayed 1161 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Nov 2014 12:33:44 EST
X-AuditID: ac160a69-f79066d000002c68-15-5460f38fdf54
From: Avi Shchislowski <avi.shchislowski@sandisk.com>
To: <ulf.hansson@linaro.org>
CC: <avi.shchislowski@sandisk.com>, <cjb@laptop.org>,
        <linux-mmc@vger.kernel.org>, <Alex.Lemberg@sandisk.com>,
        <gwendal@google.com>, Alex Lemberg <alex.lemberg@sandisk.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3]  mmc: Support FFU for eMMC v5.0
Date: Mon, 10 Nov 2014 19:18:57 +0200
Message-ID: <1415639943-12068-1-git-send-email-avi.shchislowski@sandisk.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWyRoxnkW7/54QQg1ffdCy2v97IZnF35wRG
	i8u75rBZHPnfz2hxfG24A6vHgk2lHoeurGX0uHNtD5vH501yASxRXDYpqTmZZalF+nYJXBlb
	t8oVTHGqmDttCmMD4wvTLkYODgkBE4nt69K6GDmBTDGJC/fWs3UxcnEICZxglFjUNZ8ZwtnB
	KLFyywJGiCoTib41n6ESJxklZszqYAZJsAmYSsxsW8oEMlVEQEai8YAxSA2zwB1GiTXX7oE1
	CwM139vxgx3EZhFQlZgzbRKYzSvgI/Hn6lc2iIsUJOZMsgEJcwoISGw/fYEJxBYS4Jdo29zH
	CDJTQmAeq8TyKSCngvQKSpyc+YQFxGYWkJA4+OIFM0SDpsTJhcvZJjAKz0JSNgtJ2QJGplWM
	YrmZOcW56akFhkZ6xYl5KZnF2XrJ+bmbGMFBz5W5g3HFJPNDjAIcjEo8vA5v40OEWBPLiitz
	DzFKcDArifBmPkwIEeJNSaysSi3Kjy8qzUktPsQozcGiJM4rOD3LX0ggPbEkNTs1tSC1CCbL
	xMEp1cAouTNn3pRvfzb2f5ud89axcJGW94vZHzYa6qyY7b6ouqgrdOnKrl8/zv9aw7XmTHlw
	ccJX70o/sTS1uauPHSr1cNnl+s5B3tr66Ddj6Vt7Cy590VB8VCFyxPfukoB9W7wey9zf0rP3
	foNoy/m1NTdCNjVyz/W1fBekavdE+PfB1//CLGS9BC5LKbEUZyQaajEXFScCAGzJpIt2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJMWRmVeSWpSXmKPExsXCtZEjRbf/c0KIQc9jWYubD36wWezcu47J
	YvvrjWwWd3dOYLS4vGsOm8WR//2MFsfXhjuweyzYVOpx6MpaRo871/aweUxbc57J4/MmuQDW
	KC6blNSczLLUIn27BK6MrVvlCqY4VcydNoWxgfGFaRcjJ4eEgIlE35rPzBC2mMSFe+vZuhi5
	OIQEjjNKdO5bD5ZgEzCVmNm2lAnEFhGQkuh52swMUsQscINRom/7J1aQhDDQpHs7frCD2CwC
	qhJzpk0Cs3kFfCTOvp4LZHMAbVCQmDPJBiTMKSAgsf30BbCZQgL8Em2b+xgnMPIsYGRYxSiW
	m5lTnJueWWBoqFecmJeSWZytl5yfu4kRHDickTsYn040P8TIxMEp1cCYbSZ9bae+xRP3gtDv
	x7YUFD9p2/+688OhtzfsRE7IF2i8KfX9c9rNofhwhmpMjdzJ6TseNF/z1rE7ZWOnXW1qlHix
	5UD49+Ube5muTgw68XjhiUMnzQOn69b8+6ikuERo94u5UzSP/4u5El8aOcn0tVrmducjV04s
	El7qnrsrvIHpViDre/YpSizFGYmGWsxFxYkAHQ3dHswBAAA=
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(19580405001)(68736004)(69596002)(106466001)(81156004)(110136001)(88136002)(87936001)(20776003)(47776003)(19580395003)(2351001)(64706001)(87286001)(44976005)(229853001)(104166001)(99396003)(120916001)(89996001)(86362001)(575784001)(11926002)(95666004)(84676001)(50226001)(4396001)(21056001)(33646002)(92726001)(92566001)(76176999)(97736003)(48376002)(31966008)(107046002)(77156002)(62966003)(50466002)(46102003)(102836001)(36756003)(50986999);DIR:OUT;SFP:1101;SCL:1;SRVR:CO1PR02MB127;H:milsmgep12.sandisk.com;FPR:;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Avi.Shchislowski@sandisk.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-OriginatorOrg: sandisk.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eMMC5.0 FFU is using some of pre-existing mmc_test.c functionality.
In order to prevent code duplication, some code of mmc_test.c was moved to core.c and modified.

Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 0c0fc52..e6ee0a8 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -13,6 +13,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/mmc.h>
+#include <linux/mmc/core.h>
 #include <linux/slab.h>
 
 #include <linux/scatterlist.h>
@@ -189,43 +190,8 @@ static void mmc_test_prepare_mrq(struct mmc_test_card *test,
 	struct mmc_request *mrq, struct scatterlist *sg, unsigned sg_len,
 	unsigned dev_addr, unsigned blocks, unsigned blksz, int write)
 {
-	BUG_ON(!mrq || !mrq->cmd || !mrq->data || !mrq->stop);
-
-	if (blocks > 1) {
-		mrq->cmd->opcode = write ?
-			MMC_WRITE_MULTIPLE_BLOCK : MMC_READ_MULTIPLE_BLOCK;
-	} else {
-		mrq->cmd->opcode = write ?
-			MMC_WRITE_BLOCK : MMC_READ_SINGLE_BLOCK;
-	}
-
-	mrq->cmd->arg = dev_addr;
-	if (!mmc_card_blockaddr(test->card))
-		mrq->cmd->arg <<= 9;
-
-	mrq->cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
-
-	if (blocks == 1)
-		mrq->stop = NULL;
-	else {
-		mrq->stop->opcode = MMC_STOP_TRANSMISSION;
-		mrq->stop->arg = 0;
-		mrq->stop->flags = MMC_RSP_R1B | MMC_CMD_AC;
-	}
-
-	mrq->data->blksz = blksz;
-	mrq->data->blocks = blocks;
-	mrq->data->flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
-	mrq->data->sg = sg;
-	mrq->data->sg_len = sg_len;
-
-	mmc_set_data_timeout(mrq->data, test->card);
-}
-
-static int mmc_test_busy(struct mmc_command *cmd)
-{
-	return !(cmd->resp[0] & R1_READY_FOR_DATA) ||
-		(R1_CURRENT_STATE(cmd->resp[0]) == R1_STATE_PRG);
+	mmc_prepare_mrq(test->card, mrq, sg, sg_len,
+		dev_addr, blocks, blksz, write);
 }
 
 /*
@@ -233,30 +199,9 @@ static int mmc_test_busy(struct mmc_command *cmd)
  */
 static int mmc_test_wait_busy(struct mmc_test_card *test)
 {
-	int ret, busy;
-	struct mmc_command cmd = {0};
-
-	busy = 0;
-	do {
-		memset(&cmd, 0, sizeof(struct mmc_command));
-
-		cmd.opcode = MMC_SEND_STATUS;
-		cmd.arg = test->card->rca << 16;
-		cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
-
-		ret = mmc_wait_for_cmd(test->card->host, &cmd, 0);
-		if (ret)
-			break;
-
-		if (!busy && mmc_test_busy(&cmd)) {
-			busy = 1;
-			if (test->card->host->caps & MMC_CAP_WAIT_WHILE_BUSY)
-				pr_info("%s: Warning: Host did not "
-					"wait for busy state to end.\n",
-					mmc_hostname(test->card->host));
-		}
-	} while (mmc_test_busy(&cmd));
+	int ret;
 
+	ret = mmc_wait_busy(test->card);
 	return ret;
 }
 
@@ -693,19 +638,9 @@ static int mmc_test_check_result(struct mmc_test_card *test,
 {
 	int ret;
 
-	BUG_ON(!mrq || !mrq->cmd || !mrq->data);
-
 	ret = 0;
 
-	if (!ret && mrq->cmd->error)
-		ret = mrq->cmd->error;
-	if (!ret && mrq->data->error)
-		ret = mrq->data->error;
-	if (!ret && mrq->stop && mrq->stop->error)
-		ret = mrq->stop->error;
-	if (!ret && mrq->data->bytes_xfered !=
-		mrq->data->blocks * mrq->data->blksz)
-		ret = RESULT_FAIL;
+	ret = mmc_check_result(mrq);
 
 	if (ret == -EINVAL)
 		ret = RESULT_UNSUP_HOST;
@@ -844,23 +779,13 @@ static int mmc_test_simple_transfer(struct mmc_test_card *test,
 	struct scatterlist *sg, unsigned sg_len, unsigned dev_addr,
 	unsigned blocks, unsigned blksz, int write)
 {
-	struct mmc_request mrq = {0};
-	struct mmc_command cmd = {0};
-	struct mmc_command stop = {0};
-	struct mmc_data data = {0};
-
-	mrq.cmd = &cmd;
-	mrq.data = &data;
-	mrq.stop = &stop;
+	int ret;
 
-	mmc_test_prepare_mrq(test, &mrq, sg, sg_len, dev_addr,
+	ret = mmc_simple_transfer(test->card, sg, sg_len, dev_addr,
 		blocks, blksz, write);
-
-	mmc_wait_for_req(test->card->host, &mrq);
-
-	mmc_test_wait_busy(test);
-
-	return mmc_test_check_result(test, &mrq);
+	if (ret == -EINVAL)
+		ret = RESULT_UNSUP_HOST;
+	return ret;
 }
 
 /*
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index d03a080..132da0c 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2658,6 +2658,134 @@ int mmc_pm_notify(struct notifier_block *notify_block,
 	return 0;
 }
 #endif
+/*
+ * Fill in the mmc_request structure given a set of transfer parameters.
+ */
+void mmc_prepare_mrq(struct mmc_card *card,
+	struct mmc_request *mrq, struct scatterlist *sg, unsigned sg_len,
+	unsigned dev_addr, unsigned blocks, unsigned blksz, int write)
+{
+	BUG_ON(!mrq || !mrq->cmd || !mrq->data || !mrq->stop);
+
+	if (blocks > 1) {
+		mrq->cmd->opcode = write ?
+			MMC_WRITE_MULTIPLE_BLOCK : MMC_READ_MULTIPLE_BLOCK;
+	} else {
+		mrq->cmd->opcode = write ?
+			MMC_WRITE_BLOCK : MMC_READ_SINGLE_BLOCK;
+	}
+
+	mrq->cmd->arg = dev_addr;
+	if (!mmc_card_blockaddr(card))
+		mrq->cmd->arg <<= 9;
+
+	mrq->cmd->flags = MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	if (blocks == 1)
+		mrq->stop = NULL;
+	else {
+		mrq->stop->opcode = MMC_STOP_TRANSMISSION;
+		mrq->stop->arg = 0;
+		mrq->stop->flags = MMC_RSP_R1B | MMC_CMD_AC;
+	}
+
+	mrq->data->blksz = blksz;
+	mrq->data->blocks = blocks;
+	mrq->data->flags = write ? MMC_DATA_WRITE : MMC_DATA_READ;
+	mrq->data->sg = sg;
+	mrq->data->sg_len = sg_len;
+
+	mmc_set_data_timeout(mrq->data, card);
+}
+EXPORT_SYMBOL(mmc_prepare_mrq);
+
+static int mmc_busy(struct mmc_command *cmd)
+{
+	return !(cmd->resp[0] & R1_READY_FOR_DATA) ||
+		(R1_CURRENT_STATE(cmd->resp[0]) == R1_STATE_PRG);
+}
+
+/*
+ * Wait for the card to finish the busy state
+ */
+int mmc_wait_busy(struct mmc_card *card)
+{
+	int ret, busy = 0;
+	struct mmc_command cmd = {0};
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+	cmd.opcode = MMC_SEND_STATUS;
+	cmd.arg = card->rca << 16;
+	cmd.flags = MMC_RSP_SPI_R2 | MMC_RSP_R1 | MMC_CMD_AC;
+
+	do {
+		ret = mmc_wait_for_cmd(card->host, &cmd, 0);
+		if (ret)
+			break;
+
+		if (!busy && mmc_busy(&cmd)) {
+			busy = 1;
+			if (card->host->caps & MMC_CAP_WAIT_WHILE_BUSY) {
+				pr_warn("%s: Warning: Host did not "
+					"wait for busy state to end.\n",
+					mmc_hostname(card->host));
+			}
+		}
+
+	} while (mmc_busy(&cmd));
+
+	return ret;
+}
+EXPORT_SYMBOL(mmc_wait_busy);
+
+int mmc_check_result(struct mmc_request *mrq)
+{
+	int ret;
+
+	BUG_ON(!mrq || !mrq->cmd || !mrq->data);
+
+	ret = 0;
+
+	if (!ret && mrq->cmd->error)
+		ret = mrq->cmd->error;
+	if (!ret && mrq->data->error)
+		ret = mrq->data->error;
+	if (!ret && mrq->stop && mrq->stop->error)
+		ret = mrq->stop->error;
+	if (!ret && mrq->data->bytes_xfered !=
+		mrq->data->blocks * mrq->data->blksz)
+		ret = -EPERM;
+
+	return ret;
+}
+EXPORT_SYMBOL(mmc_check_result);
+
+/*
++ * transfer with certain parameters
+ */
+int mmc_simple_transfer(struct mmc_card *card,
+	struct scatterlist *sg, unsigned sg_len, unsigned dev_addr,
+	unsigned blocks, unsigned blksz, int write)
+{
+	struct mmc_request mrq = {0};
+	struct mmc_command cmd = {0};
+	struct mmc_command stop = {0};
+	struct mmc_data data = {0};
+
+	mrq.cmd = &cmd;
+	mrq.data = &data;
+	mrq.stop = &stop;
+
+	mmc_prepare_mrq(card, &mrq, sg, sg_len, dev_addr,
+		blocks, blksz, write);
+
+	mmc_wait_for_req(card->host, &mrq);
+
+	mmc_wait_busy(card);
+
+	return mmc_check_result(&mrq);
+}
+EXPORT_SYMBOL(mmc_simple_transfer);
 
 /**
  * mmc_init_context_info() - init synchronization context
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index f206e29..92540d0 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -196,6 +196,14 @@ extern void mmc_put_card(struct mmc_card *card);
 extern int mmc_flush_cache(struct mmc_card *);
 
 extern int mmc_detect_card_removed(struct mmc_host *host);
+extern void mmc_prepare_mrq(struct mmc_card *card,
+	struct mmc_request *mrq, struct scatterlist *sg, unsigned sg_len,
+	unsigned dev_addr, unsigned blocks, unsigned blksz, int write);
+extern int mmc_wait_busy(struct mmc_card *card);
+extern int mmc_check_result(struct mmc_request *mrq);
+extern int mmc_simple_transfer(struct mmc_card *card,
+	struct scatterlist *sg, unsigned sg_len, unsigned dev_addr,
+	unsigned blocks, unsigned blksz, int write);
 
 /**
  *	mmc_claim_host - exclusively claim a host
-- 
1.7.9.5

