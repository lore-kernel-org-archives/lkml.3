Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaCYOyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 10:54:04 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:39063 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaCYOyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 10:54:02 -0400
Message-ID: <53319829.9040403@linux.vnet.ibm.com>
Date: Tue, 25 Mar 2014 20:22:25 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [V5 0/4] perf: New conditional branch filter
References: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032514-8878-0000-0000-00000B7B6ADA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 02:36 PM, Anshuman Khandual wrote:
> Hello Arnaldo,
> 
> 	I had posted the V5 version of PowerPC SW branch filter enablement
> patchset last month. Please find the patchset here at
> 
> 	https://lkml.org/lkml/2014/2/5/79
> 
> These following patches (2,4,5,6 patches from the original V5 version patchset)
> are the ones which change code in the generic kernel, perf tool and X86 perf.
> Basically this patchset adds one more branch filter for "conditional" branches.
> In X86 code, this new filter has been implemented with the help of availble SW
> filter X86_BR_JCC and LBR_JCC. We had some discussions in this regard before.
> Please review these changes and if it's okay, please merge them. Other patches
> in the series are powerpc specific and are being reviewed by Benjamin Herrenschmidt
> and Michael Ellerman. Let me know if you need more information.
> 
> [1] https://lkml.org/lkml/2013/5/22/51
> [2] https://lkml.org/lkml/2013/8/30/10
> [3] https://lkml.org/lkml/2013/10/16/75
> [4] https://lkml.org/lkml/2013/12/4/168
> [5] https://lkml.org/lkml/2014/2/5/79

Hey Arnaldo,

Do you have any comments or suggestions on this ? Have not received any
response on these proposed patch series yet. Thank you.

