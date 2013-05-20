Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3ETB6C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:58:02 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57569 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3ETB6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:58:00 -0400
X-AuditID: cbfee68f-b7f436d000000f81-07-51998326812a
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Jon Mason'" <jon.mason@intel.com>,
        cpgs@samsung.com
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] NTB: variable dereferenced before check
Date: Mon, 20 May 2013 10:57:57 +0900
Message-id: <010301ce54fd$734bce50$59e36af0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY1215pmBBv/+cFq8PKRpsaSZ2+L4
	j3PsFpd3zWGzWLDxEaMDq8fiPS+ZPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugStj8ZQmpoJe
	4YrZ51czNTD+5u9i5OSQEDCRWH/hMROELSZx4d56ti5GLg4hgWWMEj8ntbPDFJ158IMJIjGd
	UeLH4h3sEM5fRomb026AtbMJ6EocW7+FFcQWEfCWODXlFzOIzSzgL9F5cwWQzQHUwC2xujkI
	JMwpwCOx7k8nWImwgLPEtJYZLCA2i4CqxK25l8HG8ArYSZyfeYURwhaU+DH5HgvESC2J9TuP
	M0HY8hKb17wFGy8hoC7x6K8uxAUFEis3fWCHKBGR2PfiHSPIyRICx9glfu57xwaxS0Di2+RD
	LBC9shKbDjBD/CspcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRsV5xYm5x
	aV66XnJ+7iZGSET272C8e8D6EGMy0PqJzFKiyfnAiM4riTc0NjOyMDUxNTYytzQjTVhJnFet
	xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6P1hMsrAm4UdmSs237QV5w9g8l74pkEdhmd
	H9cenbj6oI3V5ZxChJW0Vnxo97nr9844Mkycb2QTO7HrG0OBJA//VSepY1VBIvtntZjLKTpa
	TbW2nMDTz9rpp3Tz1My0iCuCu/e3qZ/LUK32/H1MMm+li8vfkGvb97wR7RUMK25ouqq4sy9q
	mhJLcUaioRZzUXEiAJLwJQXeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQV215pmBBu9nsFq8PKRpsaSZ2+L4
	j3PsFpd3zWGzWLDxEaMDq8fiPS+ZPPq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4xY/GUJqaCXuGK2edXMzUw/ubvYuTkkBAwkTjz4AcThC0mceHeerYu
	Ri4OIYHpjBI/Fu9gh3D+MkrcnHYDrIpNQFfi2PotrCC2iIC3xKkpv5hBbGYBf4nOmyuAbA6g
	Bm6J1c1BIGFOAR6JdX86wUqEBZwlprXMYAGxWQRUJW7NvQw2hlfATuL8zCuMELagxI/J91gg
	RmpJrN95nAnClpfYvOYt2HgJAXWJR391IS4okFi56QM7RImIxL4X7xgnMArNQjJpFpJJs5BM
	moWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Hh/JrWDcWWDxSFGAQ5GJR7ejKCZ
	gUKsiWXFlbmHGCU4mJVEeO2sgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xFeSXxhsYm
	ZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6Ht+stKUwleJ/A1Byp++
	njifLaW2oMH7u7bEyl/WgrfPXTRffXbFS7vlnO45zxV3zpyawnxcUOSDyspS7fnTKt5I8et8
	Wmoiafydoej27SQFi/393ILVc+9z6Kv/SYwxlDm35m3wri33Q56Kxayp5Trb/1ng2M8Vopw6
	h7z9X6pfeRfabn+mSYmlOCPRUIu5qDgRAD4jAlI7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jon Mason <jon.mason@intel.com>"

commit 186f27ff9f9ec5c110739ced88ce9f8fca053882 upstream

Correct instances of variable dereferencing before checking its value on
the functions exported to the client drivers.  Also, add sanity checks
for all exported functions.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_transport.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index e0bdfd7..74c5812 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1210,12 +1210,14 @@ EXPORT_SYMBOL_GPL(ntb_transport_create_queue);
  */
 void ntb_transport_free_queue(struct ntb_transport_qp *qp)
 {
-	struct pci_dev *pdev = ntb_query_pdev(qp->ndev);
+	struct pci_dev *pdev;
 	struct ntb_queue_entry *entry;
 
 	if (!qp)
 		return;
 
+	pdev = ntb_query_pdev(qp->ndev);
+
 	cancel_delayed_work_sync(&qp->link_work);
 
 	ntb_unregister_db_callback(qp->ndev, qp->qp_num);
@@ -1371,12 +1373,13 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_up);
  */
 void ntb_transport_link_down(struct ntb_transport_qp *qp)
 {
-	struct pci_dev *pdev = ntb_query_pdev(qp->ndev);
+	struct pci_dev *pdev;
 	int rc, val;
 
 	if (!qp)
 		return;
 
+	pdev = ntb_query_pdev(qp->ndev);
 	qp->client_ready = NTB_LINK_DOWN;
 
 	rc = ntb_read_local_spad(qp->ndev, QP_LINKS, &val);
@@ -1408,6 +1411,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_down);
  */
 bool ntb_transport_link_query(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return false;
+
 	return qp->qp_link == NTB_LINK_UP;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_link_query);
@@ -1422,6 +1428,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_link_query);
  */
 unsigned char ntb_transport_qp_num(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return 0;
+
 	return qp->qp_num;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
@@ -1436,6 +1445,9 @@ EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
  */
 unsigned int ntb_transport_max_size(struct ntb_transport_qp *qp)
 {
+	if (!qp)
+		return 0;
+
 	return qp->tx_max_frame - sizeof(struct ntb_payload_header);
 }
 EXPORT_SYMBOL_GPL(ntb_transport_max_size);
-- 
1.7.9.5

