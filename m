Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3AVMgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:36:20 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:46810 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3AVMgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:36:14 -0500
Date: Tue, 22 Jan 2013 07:36:13 -0500 (EST)
From: Tom St Denis <tstdenis@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Message-ID: <644316582.100321.1358858173237.JavaMail.root@elliptictech.com>
In-Reply-To: <1706190290.100315.1358858042869.JavaMail.root@elliptictech.com>
Subject: ARM DMA Zones (coherent memory pool)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.19.111]
X-Mailer: Zimbra 7.2.1_GA_2790 (ZimbraWebClient - GC24 (Linux)/7.2.1_GA_2790)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was wondering if there was a proper way of instructing the init code (atomic_pool_init) for the DMA coherent subsystem to point to a fixed location instead of using alloc_pages()?

I ask because on our system (Zynq702/706 boards) DDR has a high latency (~25-30 cycles) whereas FPGA memory can be much quicker.  What I'd like to do is create a 256Kbyte memory in FPGA BRAMs and then have the CPU point at it for the DMA zone.

Is that at all possible through a simple kernel cmdline or patch?

Tom
