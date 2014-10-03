Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaJCLkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:40:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31231 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaJCLk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:40:26 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-99-542e8b2638e2
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/4] ima: few policy loading improvements
Date: Fri, 03 Oct 2014 14:40:17 +0300
Message-id: <cover.1412336062.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xq7rq3XohBn/LLG793cts8WVpncXL
	GfPYLS7vmsNm8aHnEZvFpxWTmB3YPHbOusvu8eDQZhaP3Qs+M3n0bVnF6PF5k1wAaxSXTUpq
	TmZZapG+XQJXxs99M1kLNrNUzL57jamB8ShzFyMnh4SAiUTzr3eMELaYxIV769lAbCGBpYwS
	l9ZVQtidTBJ7DiuA2GwCehIbmn+wg9giAjkSk85cAJvDLJAu8WlSL1hcWMBG4tDDS2AzWQRU
	JSZMPgwU5+DgFbCUeL5QHGKVnMTJY5NZJzByL2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yf
	u4kREhJfdzAuPWZ1iFGAg1GJh/fDDd0QIdbEsuLK3EOMEhzMSiK80k16IUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYV6TtfmVg+eii2kz2N8cDPFceuftRgzFXNnuC6pbJjzo2iqzZUqbw58Vk
	HxO1qBNiJVzyLmx9ew+/l7zK8erT5zlP36j8Cs+wztyjuiOLZY7nVQb+z4qXbf9uvhsd7xF7
	VMJQQ+r0g2fyfUzXX79qP2+oL8usvERqTeuGTaemd9lfO1G/sMlvixJLcUaioRZzUXEiAHQ5
	dB3nAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is few policy loading interface improvements.
Refer to the patches descriptions for details.

- Dmitry

Dmitry Kasatkin (4):
  ima: report policy load status
  ima: no need to allocate entry for comment
  ima: ignore empty and with whitespaces policy lines
  ima: use atomic bit operations to protect policy update interface

 security/integrity/ima/ima_fs.c     | 21 ++++++++++++++++-----
 security/integrity/ima/ima_policy.c | 36 ++++++++----------------------------
 2 files changed, 24 insertions(+), 33 deletions(-)

-- 
1.9.1

