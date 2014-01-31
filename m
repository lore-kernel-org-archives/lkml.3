Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaAaA4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:56:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36988 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaAaA4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:56:36 -0500
Message-ID: <52EAF4C3.1040009@infradead.org>
Date: Thu, 30 Jan 2014 16:56:35 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Long Wind <longwind2009@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: how to use memmap= option
References: <CAB-gxZAkGJpZjQMbhAm=Wip1wpm=oUvw_rUQpTkGb+n+qsgL0w@mail.gmail.com> <CAB-gxZAGL8TqvN+Jmc1vwEU+Vcos=FTWJ5No0tp-cDiJ4YPt3w@mail.gmail.com>
In-Reply-To: <CAB-gxZAGL8TqvN+Jmc1vwEU+Vcos=FTWJ5No0tp-cDiJ4YPt3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 06:06 AM, Long Wind wrote:
> On 1/8/14, Long Wind <longwind2009@gmail.com> wrote:
>> I have asked Debian users, they don't seem to know
>> kernel 2.4/2.6 fail to boot on my PC
>> probably because it can't detect my memory
>> so I have to tell kernel memory map
>>
>> the following is copied from kernel-parameters.txt:
>>
>> memmap=exactmap	[KNL,X86] Enable setting of an exact
>> 			E820 memory map, as specified by the user.
>> 			Such memmap=exactmap lines can be constructed based on
>> 			BIOS output or other requirements. See the memmap=nn@ss
>> 			option description.
>>
>>
>>
>> Could you tell me how to construct memmap= lines?
>>
> 
> Sorry, it seems that I have posted wrong list
> If you could tell me which list I should join, I will very appreciate
> I'm leaving the list


No, this is the correct mailing list for your question (or use
linux-mm@kvack.org).

First you obtain a listing of your computer's valid memory map,
either from Linux booting on it (maybe not so likely on your computer)
or maybe from BIOS SETUP.

With that information, you construct a kernel command line with multiple
memmap= options.
You can see an example of this here:
http://lkml.indiana.edu/hypermail/linux/kernel/0809.1/0664.html


Hope that helps you.
-- 
~Randy
