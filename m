Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab3KHOXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:23:11 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:45798
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031Ab3KHOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:23:09 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
X-WSS-ID: 0MVY7X7-08-77M-02
X-M-MSG: 
Message-ID: <527D5630.3000906@amd.com>
Date: Sat, 9 Nov 2013 06:22:56 +0900
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>
CC: Borislav Petkov <bp@suse.de>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>, <oleg@redhat.com>, <a.p.zijlstra@chello.nl>,
        <acme@ghostprotocols.net>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <sherry.hurwitz@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com> <20131031095829.GE2253@localhost.localdomain> <20131031104836.GC10544@pd.tnic> <20131031112328.GF2253@localhost
In-Reply-To: <20131102043438.GA11257@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2013 01:34 PM, Borislav Petkov wrote:
> On Thu, Oct 31, 2013 at 12:23:30PM +0100, Frederic Weisbecker wrote:
>> Ok we can keep that naming then, at least on the feature symbol. But
>> add a comment on it.
> Great, in the latest F16h BKDG the CPUID bit is called
> "DataBreakpointExtension". So BPEXT could mean anything :)
>
> So the comment is with the definition of the bit:
>
> +#define X86_FEATURE_BPEXT      (6*32+26) /* data breakpoint extension */
>
> Oh well...
>
Sorry for late reply.  And yes, the BDKG called it "Breakpoint Extension". Keeping the name consistent with the documentation might be best for now to avoid confusion.

So, would you like me to send in a new patch to add this comment?

Suravee


