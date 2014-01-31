Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbaAaWeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:34:21 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35358 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaAaWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:34:20 -0500
Message-ID: <52EC23B0.6010206@linux.vnet.ibm.com>
Date: Sat, 01 Feb 2014 03:59:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: lsf-pc@lists.linux-foundation.org
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [LSF/MM ATTEND] Memory Power Management
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14013122-8256-0000-0000-00000B41BC78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I would like to attend the LSF/MM Summit and discuss about the ongoing work
on developing Memory Power Management technology in the Linux kernel. Main
memory can consume a significant amount of power in the system (upto even 40%).
Hence, memory is the next big target for power-management, and this technology
can benefit computer systems ranging from mobile phones and tablets, to server
systems that form the back-bone of cloud computing infrastructures.

I have designed 3 core changes to the Linux MM subsystem to support Memory
Power Management, namely 'Sorted Buddy Page Allocator' (to influence Page
Allocation), 'Targeted Memory Compaction mechanism' (to handle memory
fragmentation) and a 'Region Allocator' as a back-end to the Page Allocator
(to serve as an anti-fragmentation scheme that boosts the success rates of
targeted memory-region evacuation).

I had got the opportunity to discuss some of these designs and algorithms
at the Linux Kernel Summit last year, where I had also presented some
interesting power-savings numbers on IBM POWER 7 hardware.

At the moment, I'm working on evaluating the patchset on newer IBM server
platforms with POWER 8 processors, and playing with different memory region
configurations on server hardware and trying to adapt my MM algorithms to
work well with large memory region sizes and fewer number of memory regions.
I'm also looking at understanding the memory access behavior of applications
that use large chunks of memory, such as KVM VM instances, and working on
tuning my patchset accordingly. At the same time, I'm helping out folks from
the ARM ecosystem to try out this patchset on their embedded boards to
evaluate the benefits on their platforms.

I would like to present the designs and algorithms behind Memory Power
Management at the summit, along with newer power-savings and performance
numbers, and thereby convince the MM maintainers about the benefits of this
feature and the elegance of its implementation.

Thank you very much.

References:
----------

1. LWN articles about Memory Power Management:

   http://lwn.net/Articles/547439/
   http://lwn.net/Articles/568891/

2. v4 of my Memory Power Management patchset:
   http://lwn.net/Articles/568369/

3. Experimental results from my patchsets:
   http://article.gmane.org/gmane.linux.power-management.general/40336
   http://article.gmane.org/gmane.linux.power-management.general/38987

4. Articles on Phoronix.com covering Memory Power Management and its
   end-user benefits:
   http://www.phoronix.com/scan.php?page=news_item&px=MTM0NzU
   http://www.phoronix.com/scan.php?page=news_item&px=MTUxMjA

Regards,
Srivatsa S. Bhat

