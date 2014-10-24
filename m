Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaJXHHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:07:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57509 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaJXHHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:07:45 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-79-5449fabdbb2b
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/2] integrity fixes
Date: Fri, 24 Oct 2014 10:07:04 +0300
Message-id: <cover.1414134113.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xa7p7f3mGGPz4IWdx6+9eZosvS+ss
	Zk9vZrJYt34xk8XLGfPYLS7vmsNm8aHnEZvFpxWTmB04PHbOusvu8eDQZhaP3Qs+M3n0fE/2
	6NuyitHjzIIj7B6fN8kFsEdx2aSk5mSWpRbp2yVwZVz7+52pYBdLxYR9Bg2MR5m7GDk5JARM
	JGbMWsgOYYtJXLi3nq2LkYtDSGApo8TMB+8YIZxOJomWDx/BqtgE9CQ2NP8As0UEciQe/XnN
	DlLELNDBKLHxx3UmkISwgLrE4h+7GUFsFgFVieZ524DiHBy8ApYSOxv4ILbJSZw8Npl1AiP3
	AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh4fNlB+PiY1aHGAU4GJV4eCuSPUKEWBPL
	iitzDzFKcDArifAmfvQMEeJNSaysSi3Kjy8qzUktPsTIxMEp1cCYITnPoVh8ecXN7fqXBRby
	xP0IzVF7Ev5wbkJdWWH84R9h0qqLDzGevMubq85Qf//OgXV3Rad/EmY1vTbvT9+bBS9NJIP+
	nHY+E5u3dv0J95X1fTKLDGJWv809/eHgpQmF/hnuP1ae/7nHzYjLWfYzO5Oh9DHvnOKngq1H
	l0nc4teZceDm6z9TlFiKMxINtZiLihMBbzvlAP0BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At first I did not notice Mimi's email with suggestion to allow
setting hash only in fix mode. Here is a next set with checking
validity of xattr type and allowing setting hash only in permissive
modes such as fix and log.

- Dmitry

Dmitry Kasatkin (2):
  ima: check xattr value length in ima_inode_setxattr()
  evm: check xattr value length in evm_inode_setxattr()

 security/integrity/evm/evm_main.c     | 11 ++++++++---
 security/integrity/ima/ima_appraise.c | 13 +++++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)

-- 
1.9.1

