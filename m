Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557AbaLKWEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:04:06 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52592 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922AbaLKWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:04:03 -0500
Message-ID: <548A14D0.7080605@gmail.com>
Date: Thu, 11 Dec 2014 14:04:00 -0800
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alexander.h.duyck@redhat.com, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.desnoyers@polymtl.ca, peterz@infradead.org,
        benh@kernel.crashing.org, heiko.carstens@de.ibm.com, mingo@kernel.org,
        mikey@neuling.org, linux@arm.linux.org.uk, donald.c.skidmore@intel.com,
        matthew.vick@intel.com, geert@linux-m68k.org,
        jeffrey.t.kirsher@intel.com, romieu@fr.zoreil.com,
        paulmck@linux.vnet.ibm.com, nic_swsd@realtek.com, will.deacon@arm.com,
        michael@ellerman.id.au, tony.luck@intel.com,
        torvalds@linux-foundation.org, oleg@redhat.com, schwidefsky@de.ibm.com,
        fweisbec@gmail.com
Subject: Re: [PATCH v7 0/4] arch: Add lightweight memory barriers for coherent
 memory access
References: <20141125203310.8240.27370.stgit@ahduyck-server>	<54892B87.3020909@gmail.com> <20141211.153204.228153607927530694.davem@davemloft.net>
In-Reply-To: <20141211.153204.228153607927530694.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 12:32 PM, David Miller wrote:
> From: Alexander Duyck <alexander.duyck@gmail.com>
> Date: Wed, 10 Dec 2014 21:28:39 -0800
>
>> It occurs to me that I never got a sign off from any of the maintainers
>> on getting this pulled in.
>>
>> Since the merge window is open I was wondering which tree I should make
>> sure these patches apply to and who will be the one to pull them in?
>> Since I was modifying network drivers should I resubmit them for netdev,
>> or should I submit them for asm-generic or some other tree?
> I have no problem taking this via my tree, but I want to see agreement
> from other interested parties.

I'll resubmit them as a net-next submission after I verify that they
still apply cleanly and there aren't any build issues.

- Alex
