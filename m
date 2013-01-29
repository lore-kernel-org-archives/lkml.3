Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3A2WOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:14:32 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14879 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab3A2WOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:14:31 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
X-WSS-ID: 0MHER3X-01-BMB-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
CC: <Jacob.Shin@amd.com>, <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH v2 0/2] Enable WC+ memory type on AMD family 10h processors
Date: Tue, 29 Jan 2013 17:14:13 -0500
Message-ID: <1359497653-24684-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending since previous message went with incorrect From header. Also
fixing redundant check in the second patch.

Enable WC+ memory type on AMD family 10h processors if BIOS doesn't do
this. WC+ is used only in in virtualized scenarios and never in bare metal
cases (see AMD APM v2).

Also clean up init_amd() a little.

Boris Ostrovsky (2):
  AMD,x86: Clean up init_amd()
  x86,AMD: Enable WC+ memory type on family 10 processors

 arch/x86/include/uapi/asm/msr-index.h |    1 +
 arch/x86/kernel/cpu/amd.c             |   49 ++++++++++++++++++---------------
 2 files changed, 28 insertions(+), 22 deletions(-)


