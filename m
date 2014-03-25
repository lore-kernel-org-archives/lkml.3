Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaCYSch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:32:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40367 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaCYScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:32:35 -0400
Message-ID: <5331CBB0.8080500@linux.vnet.ibm.com>
Date: Tue, 25 Mar 2014 11:32:16 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        scottwood@freescale.com
Subject: Re: [PATCH v4 09/11] powerpc/perf: add support for the hv 24x7 interface
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com> <1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com> <20140325214356.4a2f7d95@kryten>
In-Reply-To: <20140325214356.4a2f7d95@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032518-0928-0000-0000-000000BAC770
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 03:43 AM, Anton Blanchard wrote:
>
> Hi Cody,
>
> hv-24x7: could not obtain capabilities, error 0x                                                                fffffffffffffffe, not enabling
> hv-gpci: could not obtain capabilities, error 0x                                                                fffffffffffffffe, not enabling
>
>> +		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",
>
> That's a lot of padding :)
>
> I think this should also be a pr_debug, considering this is not relevant
> to most ppc64 boxes.

Yep, s/info/debug/ makes sense. The format should have been "%08lx" not 
"%80lx", not sure when I screwed that up.

