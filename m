Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3JBQyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:54:11 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:51970
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521Ab3JBQyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:54:09 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
X-WSS-ID: 0MU1W0G-07-9EJ-02
X-M-MSG: 
Message-ID: <524C4FAA.2040506@amd.com>
Date: Wed, 2 Oct 2013 11:54:02 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: <fweisbec@gmail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>, <a.p.zijlstra@chello.nl>,
        <acme@ghostprotocols.net>, <hpa@zytor.com>, <tgl@domain.invalid>,
        <linux-kernel@vger.kernel.org>, <sherry.hurwitz@amd.com>
Subject: Re: [PATCH V5 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint Extensions
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com> <20131002161547.GA15390@redhat.com>
In-Reply-To: <20131002161547.GA15390@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2013 11:15 AM, Oleg Nesterov wrote:
> On 10/02,suravee.suthikulpanit@amd.com  wrote:
>> >
>> >From: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> >
>> >Frederic, this is the rebase of the V4 patch onto the linux-3.12.0-rc3 (linux.git),
>> >and retest.
> But the code is the same? If yes,
>
> Reviewed-by: Oleg Nesterov<oleg@redhat.com>

The only change I made was in the tools/perf/util/parse-events.y due to change in parse_events_add_breakpoint(), but should be the same logic.

Suravee.


