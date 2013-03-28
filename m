Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3C1DJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 23:09:52 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:25288
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251Ab3C1DJv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 23:09:51 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z1039mzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1364440182.2289.45.camel@leyfoon-vm>
Subject: Generic syscall ABI support
From: Ley Foon Tan <lftan@altera.com>
To: <linux-kernel@vger.kernel.org>, <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>
Date: Thu, 28 Mar 2013 11:09:42 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need advise regarding the generic syscall ABI support.

We are planning to upstream our Nios II kernel (arch/nios2) to mainline.
But it doesn't support generic syscall ABI yet (It requires an updated
Glibc port as well). 

The question is, is it a requirement for new arch to support generic
syscall ABI when upstreaming? Can we upstream a non-generic syscall ABI
first and migrate to generic syscall ABI in future?
Thanks.

Regards
LFTAN



