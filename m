Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3EUN3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:29:52 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:16982
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab3EUN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:29:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN5HHK-02-99F-02
X-M-MSG: 
Message-ID: <519B76CB.1000208@amd.com>
Date: Tue, 21 May 2013 08:29:47 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
Subject: Re: [PATCH 0/2 V3] perf/x86/amd: IOMMU Performance Counter Support
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com> <519A4429.30405@amd.com> <20130521091157.GD26912@twins.programming.kicks-ass.net>
In-Reply-To: <20130521091157.GD26912@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2013 4:11 AM, Peter Zijlstra wrote:
> On Mon, May 20, 2013 at 10:41:29AM -0500, Suravee Suthikulanit wrote:
>> Peter,
>>
>> Please let me know if you have any questions/concerns regarding the PMU
>> implementation.
> Looks good, how would you like to go about merging this? Should I push
> it through Ingo's tree or do you prefer it goes through some IOMMU tree?
>
Thank you, Peter.  Since this is mostly PERF-related feature, I think it 
would be appropriate to push this through Ingo's tree.

Suravee

