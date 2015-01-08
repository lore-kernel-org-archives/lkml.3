Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbbAHRaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:30:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbbAHRaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:30:10 -0500
Message-ID: <54AEBE84.6090307@redhat.com>
Date: Thu, 08 Jan 2015 11:29:40 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.19-rc3
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <54AE7D53.2020305@redhat.com> <20150108134520.GC14200@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150108134520.GC14200@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 07:45 AM, Catalin Marinas wrote:
> On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
>> On 01/05/2015 07:46 PM, Linus Torvalds wrote:
>>> It's a day delayed - not because of any particular development issues,
>>> but simply because I was tiling a bathroom yesterday. But rc3 is out
>>> there now, and things have stayed reasonably calm. I really hope that
>>> implies that 3.19 is looking good, but it's equally likely that it's
>>> just that people are still recovering from the holiday season.
>>
>> I'm consistently getting an out of memory killer triggered when
>> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
>> with 16 GB of memory. This doesn't happen when running a 3.18
>> kernel.
>>
>> I'm going to start bisecting the failure now, but here's the crash
>> log in case someone can see something obvious in it.

> Can you disable (transparent) huge pages? I don't have any better at the
> moment suggestion apart from bisecting.

I didn't have transparent huge pages on. Turning off hugetblfs didn't
change anything. Turning off 64K pages isn't an option because of
firmware constraints.

--Mark Langsdorf

