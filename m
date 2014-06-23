Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaFWBrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:47:33 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44813 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbaFWBrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:47:31 -0400
X-IronPort-AV: E=Sophos;i="5.00,758,1396972800"; 
   d="scan'208";a="32261780"
Message-ID: <53A78770.7080108@cn.fujitsu.com>
Date: Mon, 23 Jun 2014 09:48:32 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, <pbonzini@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <mgorman@suse.de>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <laijs@cn.fujitsu.com>, <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi.kivity@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [RFC PATCH 1/1] Move two pinned pages to non-movable node in
 kvm.
References: <1403070600-6083-1-git-send-email-tangchen@cn.fujitsu.com> <20140618061230.GA10948@minantech.com> <53A136C4.5070206@cn.fujitsu.com> <20140619092031.GA429@minantech.com> <20140619190024.GA3887@amt.cnet> <20140620111509.GE20764@minantech.com> <20140620125326.GA22283@amt.cnet> <20140620142622.GA28698@minantech.com> <20140620203146.GA6580@amt.cnet> <20140620203903.GA7838@amt.cnet>
In-Reply-To: <20140620203903.GA7838@amt.cnet>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo, Gleb,

Sorry for the delayed reply and thanks for the advices.

On 06/21/2014 04:39 AM, Marcelo Tosatti wrote:
> On Fri, Jun 20, 2014 at 05:31:46PM -0300, Marcelo Tosatti wrote:
>>> IIRC your shadow page pinning patch series support flushing of ptes
>>> by mmu notifier by forcing MMU reload and, as a result, faulting in of
>>> pinned pages during next entry.  Your patch series does not pin pages
>>> by elevating their page count.
>>
>> No but PEBS series does and its required to stop swap-out
>> of the page.
>
> Well actually no because of mmu notifiers.
>
> Tang, can you implement mmu notifiers for the other breaker of
> mem hotplug ?

I'll try the mmu notifier idea and send a patch soon.

Thanks.
