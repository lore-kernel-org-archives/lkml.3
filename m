Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaKUK1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:27:11 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59352 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaKUK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:27:08 -0500
Message-ID: <546F1367.4060301@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2014 15:56:47 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Denis Kirjanov <kirjanov@gmail.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mikey@neuling.org,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        peterz@infradead.org, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, tglx@linutronix.de, davej@redhat.com,
        akpm@linux-foundation.org, sukadev@linux.vnet.ibm.com,
        davem@davemloft.net, sam.bobroff@au1.ibm.com
Subject: Re: [PATCH V4 7/8] powerpc, ptrace: Enable support for miscellaneous
 debug registers
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com> <1415683597-22819-8-git-send-email-khandual@linux.vnet.ibm.com> <54647DA7.1070000@linux.vnet.ibm.com> <CAHj3AVna2H1VZvP0=Xjw9pqS+gRKR7_KH9FNhX3vUBFh7OU2wA@mail.gmail.com>
In-Reply-To: <CAHj3AVna2H1VZvP0=Xjw9pqS+gRKR7_KH9FNhX3vUBFh7OU2wA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112110-0033-0000-0000-000000908376
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 03:30 PM, Denis Kirjanov wrote:
> On 11/13/14, Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:
>> > On 11/11/2014 10:56 AM, Anshuman Khandual wrote:
>>> >> This patch enables get and set of miscellaneous debug registers through
>>> >> ptrace PTRACE_GETREGSET-PTRACE_SETREGSET interface by implementing new
>>> >> powerpc specific register set REGSET_MISC support corresponding to the
>>> >> new ELF core note NT_PPC_MISC added previously in this regard.
>> >
>> > Right now this one does not compile for "ppc64e_defconfig" and
>> > "pmac32_defconfig" config options. The patch below will fix it
>> > and would be part of next revision.
> It would be great to have a test tool for that under
> tools/testing/selftests/ptrace/
> 

Hey Denis,

I have already added one test case under selftests/powerpc/tm/ which
will test all the newly added ELF core note based ptrace requests on
powerpc. This test case is added as part of the next patch 8/8 in
the series. Please let me know if the test case does not cover something
you are looking for.  

