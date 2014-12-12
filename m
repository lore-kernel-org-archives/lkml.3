Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030867AbaLLQkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:40:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47892 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030331AbaLLQkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:40:46 -0500
Message-ID: <548B1A7D.7040403@zytor.com>
Date: Fri, 12 Dec 2014 08:40:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT pull] x86 mpx support for 3.19
References: <alpine.DEB.2.11.1412091504490.16275@nanos>	<CA+55aFyu4HYdWzqOuCYb_pRKOZU==xbxTyuBHSn+wV8gT7q+rw@mail.gmail.com>	<5488A203.7000600@linux.intel.com>	<CA+55aFwTpZ8U7vUvBE8xkX1_vfktyVDcCwchssMhhP44M8TzUg@mail.gmail.com>	<5488AF8D.5070702@linux.intel.com> <CA+55aFwzCuFCzASb4Kj1WC7S9v1wSKN2dHj_ns_1uy2GG6Svqw@mail.gmail.com>
In-Reply-To: <CA+55aFwzCuFCzASb4Kj1WC7S9v1wSKN2dHj_ns_1uy2GG6Svqw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 12:49 PM, Linus Torvalds wrote:
> On Wed, Dec 10, 2014 at 12:39 PM, Dave Hansen
> <dave.hansen@linux.intel.com> wrote:
>>
>> I misspoke there.  I meant SMAP (I placed MPX below its config option).
> 
> Ok, I agree on SMAP, we might want to have that be configurable too,
> especially for smaller systems (I *think* SMAP is big-core only,
> right?). I'm not sure how much of a possible performance downside it
> has, but it does add instructions to potentially critical areas.
> 

*As far as I know*, SMAP will be pushed into all CPUs over time.

SMAP is already configurable, although the overhead on non-SMAP-enabled
hardware is minimal (the CLAC/STAC instructions get patched out.)

	-hpa


