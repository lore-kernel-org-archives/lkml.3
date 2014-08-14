Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaHNAVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:21:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18316 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaHNAVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:21:07 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-77-53ec00ef7937
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/4] extcon: sm5502: Clean up codes by using checkpatch script
Date: Thu, 14 Aug 2014 09:20:59 +0900
Message-id: <1407975660-3993-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
References: <1407975660-3993-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkUPc9w5tgg63bbSyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6M+UcWsxU08lVcbL7A3sC4
	iruLkZNDQsBE4tqXV+wQtpjEhXvr2UBsIYGljBIf/uZ3MXKA1ZyaIdLFyAUUns4ocWXjeyYI
	p4lJ4vTPnWANbAJaEvtf3ACzRQQUJDb3PmMFsZkF4iXOdnczgtjCAgESpx7PBYuzCKhK/N5w
	jwXE5hVwkTj99BwTxBFyEh/2PAI7iFPAVWLqiU/MEAe5SDxfMZcNouY9m8TyiQYQcwQkvk0+
	xAJxqKzEpgPMECWSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgmJ7+
	96x3B+PtA9aHGJOBxk1klhJNzgeGeV5JvKGxmZGFqYmpsZG5pRlpwkrivEkPk4KEBNITS1Kz
	U1MLUovii0pzUosPMTJxcEo1MJ6/H8mzZOmXtywZt5y3T33lnSL3z+9XwIVHl2RW6Acy6Cbm
	5M2ZzNH4jO37XQG5uKnpsezzlvw9G+/KG/nJxWfeGlv79Ev/rfeoqYh9ZD7BXB/t1sMkusHJ
	WvjQ+/DHVz+L3NvAc9Jcnnf/7ytuf09zJx537lt3ZWrCbtk7Z9y1d0//dK8w10mJpTgj0VCL
	uag4EQBPffZvaQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoO57hjfBBmtmmlpc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGfOPLGYraOSruNh8gb2BcRV3FyMHh4SAicSpGSJdjJxAppjEhXvr2boYuTiEBKYz
	SlzZ+J4Jwmlikjj9cycbSBWbgJbE/hc3wGwRAQWJzb3PWEFsZoF4ibPd3YwgtrBAgMSpx3PB
	4iwCqhK/N9xjAbF5BVwkTj89xwSxTU7iw55H7CA2p4CrxNQTn5hBbCGgmucr5rJNYORdwMiw
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Ep5J72Bc1WBxiFGAg1GJh9cj6nWwEGtiWXFl
	7iFGCQ5mJRFev91AId6UxMqq1KL8+KLSnNTiQ4ymQFdNZJYSTc4HRmleSbyhsYmZkaWRuaGF
	kbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZGwdKXYpd3CBx3WeX8bfWra2r5jk4qp27b
	ZvBsDvu378umbWWWSy6LiBj/uzV/qeM06wnb3AS33eE6My9Mw0Z823c1HX33hdoX6jy9BU1V
	fh6Y5s/LOef4xb4DUQ6VBcayTu/XvEmVvl25uOuCvfmy/NqweR7nfl4/7xsVlyf05pS4NCf3
	7HZRJZbijERDLeai4kQA6QTUSpoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just clean up codes by using checkpatch script and fix warning
message about if statement.

- the result of checkpatch script as following:
WARNING: void function return statements are not generally useful
+	return;
+}

WARNING: quoted string split across lines
+			dev_err(info->dev, "failed: irq request (IRQ: %d,"
+				" error :%d)\n", muic_irq->irq, ret);

- warning message about coding style.
	drivers/extcon/extcon-sm5502.c:398 sm5502_muic_cable_handler()
		warn: we tested 'attached' before and it was 'false'

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-sm5502.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index f94d66a..8e6e669 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -391,7 +391,7 @@ static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
 	/* Get the type of attached or detached cable */
 	if (attached)
 		cable_type = sm5502_muic_get_cable_type(info);
-	else if (!attached)
+	else
 		cable_type = prev_cable_type;
 	prev_cable_type = cable_type;
 
@@ -453,8 +453,6 @@ static void sm5502_muic_irq_work(struct work_struct *work)
 		dev_err(info->dev, "failed to handle MUIC interrupt\n");
 
 	mutex_unlock(&info->mutex);
-
-	return;
 }
 
 /*
@@ -613,8 +611,9 @@ static int sm5022_muic_i2c_probe(struct i2c_client *i2c,
 						IRQF_NO_SUSPEND,
 						muic_irq->name, info);
 		if (ret) {
-			dev_err(info->dev, "failed: irq request (IRQ: %d,"
-				" error :%d)\n", muic_irq->irq, ret);
+			dev_err(info->dev,
+				"failed: irq request (IRQ: %d, error :%d)\n",
+				muic_irq->irq, ret);
 			return ret;
 		}
 	}
-- 
1.8.0

