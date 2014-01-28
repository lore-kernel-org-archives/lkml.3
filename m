Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaA1W4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:56:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:23743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbaA1W4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:56:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,739,1384329600"; 
   d="scan'208";a="474028940"
Message-ID: <52E83577.6040504@intel.com>
Date: Tue, 28 Jan 2014 14:55:51 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>	<52E82A40.3040104@intel.com> <CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
In-Reply-To: <CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 02:47 PM, Yinghai Lu wrote:
> On Tue, Jan 28, 2014 at 2:08 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>> On 01/28/2014 02:04 PM, Yinghai Lu wrote:
>>> In original bootmem wrapper for memblock, we have limit checking.
>>>
>>> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
>>>
>> Do you have a git tree or cumulative set of patches that you'd like us
>> to all test?  I'm happy to boot it on my system, I just want to make
>> sure I've got the same set that you're testing.
> 
> This one should only affect on arm and x86 the 32 bit kernel with more
> then 4G RAM.

OK, let me rephrase.

Does anyone want me to test this on a 1TB 64-bit x86 system?  If yes,
please tell me which patches you want me to test, and on top of which
kernel.  I have three patches in this area, I think, but I don't want to
waste my time testing and reporting the wrong thing.


