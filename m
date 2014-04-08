Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaDHVAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:00:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37101 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbaDHVAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:00:46 -0400
Message-ID: <5344631D.1050203@zytor.com>
Date: Tue, 08 Apr 2014 13:59:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: Mel Gorman <mgorman@suse.de>, Cyrill Gorcunov <gorcunov@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 2/3] x86: Define _PAGE_NUMA with unused physical address
 bits PMD and PTE levels
References: <1396883443-11696-1-git-send-email-mgorman@suse.de>	<1396883443-11696-3-git-send-email-mgorman@suse.de>	<5342C517.2020305@citrix.com>	<20140407154935.GD7292@suse.de>	<20140407161910.GJ1444@moon>	<20140407182854.GH7292@suse.de>	<5342FC0E.9080701@zytor.com>	<20140407193646.GC23983@moon>	<5342FFB0.6010501@zytor.com>	<20140407212535.GJ7292@suse.de>	<CAKbGBLhsWKVYnBqR0ZJ2kfaF_h=XAYkjq=v3RLoRBDkF_w=6ag@mail.gmail.com>	<e9801da2-3aa4-4c23-9a64-90c890b9ebbc@email.android.com> <CAKbGBLjO7pneg_5nXcRXK-9iToZvPkJVZ=AQBfaZkZjU9iN2BA@mail.gmail.com>
In-Reply-To: <CAKbGBLjO7pneg_5nXcRXK-9iToZvPkJVZ=AQBfaZkZjU9iN2BA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 01:51 PM, Steven Noonan wrote:
> On Tue, Apr 8, 2014 at 8:16 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> <snark>
>>
>> Of course, it would also be preferable if Amazon (or anything else) didn't need Xen PV :(
> 
> Well Amazon doesn't expose NUMA on PV, only on HVM guests.
> 

Yes, but Amazon is one of the main things keeping Xen PV alive as far as
I can tell, which means the support gets built in, and so on.

	-hpa


