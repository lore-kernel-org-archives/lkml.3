Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3B0Tv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:51:27 -0500
Received: from furnace.wzff.de ([176.9.216.40]:32149 "EHLO furnace.wzff.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3B0TvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:51:22 -0500
Message-ID: <512E639F.4010904@barfooze.de>
Date: Wed, 27 Feb 2013 20:50:55 +0100
From: John Spencer <maillist-linux@barfooze.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Mail/1.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 0/3] build linux-next without perl
References: <512E3A83.2050501@barfooze.de> <20130227185328.GA27243@merkur.ravnborg.org>
In-Reply-To: <20130227185328.GA27243@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 07:53 PM, Sam Ravnborg wrote:
> On Wed, Feb 27, 2013 at 05:55:31PM +0100, John Spencer wrote:
>> Rob Landley wrote:
>>>   Before 2.6.25 building Linux never required perl. This patch series
>> removes
>>>   the requirement from basic kernel builds (tested on i686, x86_64, arm,
>>>
>> mips,
>>>   powerpc, sparc, sh4, and m68k). Now updated to 3.8-rc1.
>>
>> using this patch series since 2.6.32 in sabotage linux, it is highly
>> useful and it's about time to get it merged.
>> tested against linux 3.8, works perfectly.
>
> Why do you apply this patch serie to sabotage linux?
>
> 	Sam
>

it allows me to build the kernel as soon as the minimal base system is 
bootstrapped. building perl takes about as long as the whole base system 
(busybox,gcc,binutils,make) together, so having that dependency removed 
is a huge relief.

btw, bootstrap-linux [1] uses this patch series as well.

[1] https://github.com/pikhq/bootstrap-linux
