Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3DOH7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:59:12 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:47034 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873Ab3DOH7J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:59:09 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1366012739.21182.4.camel@leyfoon-vm>
Subject: Linux kernel support -O0 optimization flag?
From: Ley Foon Tan <lftan@altera.com>
To: <linux-kernel@vger.kernel.org>
CC: Kenneth Chong Yin Tan <cytan@altera.com>
Date: Mon, 15 Apr 2013 15:58:59 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Change KBUILD_CFLAGS to -O0 in Makefile and got the compilation error as
below.
Is the Linux kernel support -O0 optimization flag?
Note, I have tried 2 architecture compilers and got the same error.



In function 'zap_pmd_range',

    inlined from 'zap_pud_range' at mm/memory.c:1288:8,

    inlined from 'unmap_page_range' at mm/memory.c:1313:8:

mm/memory.c:1243:23: error: call to '__build_bug_failed' declared with
attribute error: BUILD_BUG failed

make[1]: *** [mm/memory.o] Error 1

