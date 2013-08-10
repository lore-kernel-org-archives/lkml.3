Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968363Ab3HJBSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 21:18:38 -0400
Received: from www.sr71.net ([198.145.64.142]:60337 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968333Ab3HJBSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 21:18:37 -0400
Message-ID: <52059508.3090405@sr71.net>
Date: Fri, 09 Aug 2013 18:19:04 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
References: <520578D0.7020607@intel.com> <CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com>
In-Reply-To: <CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 04:23 PM, Yinghai Lu wrote:
> On Fri, Aug 9, 2013 at 4:18 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>> I'm getting a 100% reproducible panic early in boot:
...
>>> early console in setup code
>>> [    0.000000] Initializing cgroup subsys cpuset
>>> [    0.000000] Initializing cgroup subsys cpu
>>> [    0.000000] Linux version 3.8.0-rc5-00059-g8170e6b
> 
> so how about v3.10?
> 
> We should have some fixes in 3.10 already.

I was hitting it on Linus's current tree today (3.11-rcwhatever).  I
pasted the panic() from your patch's commit specifically, but the same
behavior is happening on current kernels, and it looked consistent as I
bisected between the 3.11-rc's and your commit.
