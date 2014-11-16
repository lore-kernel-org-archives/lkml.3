Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaKPIdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 03:33:15 -0500
Received: from mailsec118.isp.belgacom.be ([195.238.20.114]:46376 "EHLO
	mailsec118.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbaKPIdO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 03:33:14 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=IWjTSwFp5QM033bvc92RfzEeQuXC3aWfw/K7N4S/aa4= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=gu6fZOg2AAAA:8 a=QdXaasrc4sTjBr73Ip0A:9
 a=QEXdDO2ut3YA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=Go_CdD27iwAA:10
 a=UwNzbkySZT0A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0LANRgaFTD7hTU/2dsb2JhbABbgw5VWoMFtUYGkzyHToELFgEBAQEBfYQsVhUEHAIYDgJfJIg0CZ1qlGCIEYcCjnuBLYURimSCfoFUBZciiF49kH+ECoFHgjY8gnsBAQE
Date: Sun, 16 Nov 2014 09:33:12 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <393289076.116745.1416126792518.open-xchange@webmail.nmp.skynet.be>
Subject: frequent lockups in 3.18rc4: revert suggestion
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

        I was reading your report
http://marc.info/?l=linux-kernel&m=141600070111887&w=2

        Have you tried reverting the following patches (all from rc1) ?
       
        c6f4459 v3.18-rc1 smp: Add new wake_up_all_idle_cpus() function
        bb964a9 v3.18-rc1 kernel misc: Replace __get_cpu_var uses
        2ed903c v3.18-rc1 cpuidle: Use wake_up_all_idle_cpus() to wake up all
idle cpus

Regards,
Fabian
