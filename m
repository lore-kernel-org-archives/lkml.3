Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3A2VcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:32:23 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:17992 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab3A2VcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:32:21 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz32i87h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0MHEP58-02-B0T-02
X-M-MSG: 
From: Boris Ostrovsky <ostr@amd64.org>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
CC: <Jacob.Shin@amd.com>, <bp@alien8.de>, <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH 0/2] Enable WC+ memory type on AMD family 10h processors
Date: Tue, 29 Jan 2013 16:31:55 -0500
Message-ID: <1359495115-23181-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

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


