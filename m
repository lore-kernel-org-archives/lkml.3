Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3HLIU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:20:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29395 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3HLIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:20:24 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-a6-52089ac72e71
From: Jingoo Han <jg1.han@samsung.com>
To: "'Ohad Ben-Cohen'" <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] remoteproc: ste_modem: Staticize local symbols
Date: Mon, 12 Aug 2013 17:20:22 +0900
Message-id: <000201ce9734$ca5e8a10$5f1b9e30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6XNKt7AhfDSgeYSKCWr1zV6Bh3Nw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zI93jsziCDP5ME7W4vPASq8XlXXPY
	LH6v/sHswOzRt2UVo8fnTXIenz7tYwtgjuKySUnNySxLLdK3S+DKWLHkCGvBC66KvZu2MjYw
	TuXsYuTgkBAwkfh1vKqLkRPIFJO4cG89G4gtJLCMUeLxYXGIuInEndbnQHEuoPgiRonOC3eZ
	IZxfjBKfLj1lB6liE1CT+PLlMJgtAmTvP9/JBGIzCzhJ/NwykwXEFhawl9i6+DGYzSKgKrH8
	0ApGEJtXwFJi0c1prBC2oMSPyfdYIHq1JNbvPA41R15i85q3zBAXKUjsOPuaEWKXnsSCph9Q
	NSIS+168YwQ5TkJgHrvEwXMbmSGWCUh8m3yIBeJjWYlNB6DmSEocXHGDZQKj2Cwkq2chWT0L
	yepZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRESURN2MN47YH2IMRlo/URmKdHk
	fGBE5pXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	sej7x39FoZvvCM05uZTJZucvdpYDlq8auBrfHnjFHb1KNOrYD2mzuCcPcmo2rSiR2xlVtWjG
	M9tVHsEJM2qabyit1NJgcHjasm7Vs73Tf1zgtmDniQ5b/a/cQ6I7lv1YiPXePzZf+LXYHBtM
	MhoexC05MuFtx6SpFaJzE7c3rTS5xaxVmxDAqsRSnJFoqMVcVJwIADVZHxa+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7xWRxBBltPCVpcXniJ1eLyrjls
	Fr9X/2B2YPbo27KK0ePzJjmPT5/2sQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZqxYcoS14AVXxd5NWxkbGKdydjFyckgImEjcaX3OBmGLSVy4tx7I5uIQEljEKNF5
	4S4zhPOLUeLTpafsIFVsAmoSX74cBrNFgOz95zuZQGxmASeJn1tmsoDYwgL2ElsXPwazWQRU
	JZYfWsEIYvMKWEosujmNFcIWlPgx+R4LRK+WxPqdx6HmyEtsXvOWGeIiBYkdZ18zQuzSk1jQ
	9AOqRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwzD6T2sG4ssHiEKMAB6MSD6/HF/YgIdbEsuLK3EOMEhzMSiK8vI0cQUK8KYmVValF+fFF
	pTmpxYcYk4E+ncgsJZqcD0wneSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXA2Ooh1drVvtnmtf1Ls9cd5qYvQz9ZpoRwvruVUJJkZjxt+bvi2pOrNh1LFt3R
	eulv3CTW0/PbU3MqQj+tcTR/5fTiwuuzH9SM/seoRacuPeQb93LtvWvVZ99osDx99EvTaEf9
	P/vUtdyqbW4ekk2te03YavWj/TuPu/1QuLb9cOSrT65Ou17bKLEUZyQaajEXFScCACu2IF8d	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These local symbols are used only in this file.
Fix the following sparse warnings:

drivers/remoteproc/ste_modem_rproc.c:167:27: warning: symbol 'sproc_fw_ops' was not declared. Should it be static?
drivers/remoteproc/ste_modem_rproc.c:196:25: warning: symbol 'sproc_dev_cb' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/remoteproc/ste_modem_rproc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
index 1ec39a4..c4ac910 100644
--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -164,7 +164,7 @@ sproc_find_loaded_rsc_table(struct rproc *rproc, const struct firmware *fw)
 }
 
 /* STE modem firmware handler operations */
-const struct rproc_fw_ops sproc_fw_ops = {
+static const struct rproc_fw_ops sproc_fw_ops = {
 	.load = sproc_load_segments,
 	.find_rsc_table = sproc_find_rsc_table,
 	.find_loaded_rsc_table = sproc_find_loaded_rsc_table,
@@ -193,7 +193,7 @@ static void sproc_kick_callback(struct ste_modem_device *mdev, int vqid)
 		sproc_dbg(sproc, "no message was found in vqid %d\n", vqid);
 }
 
-struct ste_modem_dev_cb sproc_dev_cb = {
+static struct ste_modem_dev_cb sproc_dev_cb = {
 	.kick = sproc_kick_callback,
 };
 
-- 
1.7.10.4


