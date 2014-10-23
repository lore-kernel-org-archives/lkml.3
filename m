Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaJWNtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:49:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35426 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaJWNtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:49:13 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-74-544907562a24
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/2] integrity fixes
Date: Thu, 23 Oct 2014 16:47:16 +0300
Message-id: <cover.1414071910.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xa7ph7J4hBie2WVnc+ruX2eLL0jqL
	2dObmSxezpjHbnF51xw2iw89j9gsPq2YxOzA7rFz1l12jweHNrN47F7wmcmjb8sqRo8zC46w
	e3zeJBfAFsVlk5Kak1mWWqRvl8CVcafzG2vBOeaKnqWTGRsY3zJ1MXJySAiYSOyacJwZwhaT
	uHBvPVsXIxeHkMBSRoljG/tZIJxOJol/Lc/YQarYBPQkNjT/ALNFBHIkHv15DWYzC5RKfPh+
	EWgSB4ewgIrEixnuIGEWAVWJthW32UBsXgFLiUVLH7FBLJOTOHlsMusERu4FjAyrGEVTS5ML
	ipPSc430ihNzi0vz0vWS83M3MUKC5esOxqXHrA4xCnAwKvHwViR7hAixJpYVV+YeYpTgYFYS
	4Y1n9QwR4k1JrKxKLcqPLyrNSS0+xMjEwSnVwCjOtuV5gaavZKd+uYDqwUnKMY/9WR39uJpM
	AyMOt+6Ql0/oXl8eV9GeVdWx/ZNsvGfIMa0PQmXLNF/PWVt6PCBYyT8l8hmv25wZT3ZJBuSk
	evT13zz4mq1x+uFfLQmv7tT9nvdo8ptNJw5zOp5wOsA70+XQUUv9Cayi3jIHhUuk8xt+bHqy
	VImlOCPRUIu5qDgRAA3Fi7D0AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is couple of patches to fix bugs reported by Jan Kara
to prevent kernel oopses when setxattr() is called without
xattr values.

- Dmitry

Dmitry Kasatkin (2):
  ima: check xattr value length in ima_inode_setxattr()
  evm: check xattr value length in evm_inode_setxattr()

 security/integrity/evm/evm_main.c     | 9 ++++++---
 security/integrity/ima/ima_appraise.c | 2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
1.9.1

