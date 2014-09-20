Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaITEIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 00:08:40 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59595 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaITEIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 00:08:39 -0400
Message-ID: <541CFDBE.6090600@gmail.com>
Date: Sat, 20 Sep 2014 12:08:30 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
References: <541552B8.8020807@gmail.com> <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com> <20140915085029.GY4659@axis.com> <5416C941.9020503@gmail.com>
In-Reply-To: <5416C941.9020503@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 07:10 PM, Chen Gang wrote:
> On 9/15/14 16:50, Jesper Nilsson wrote:
>> On Sun, Sep 14, 2014 at 10:45:23AM +0200, Geert Uytterhoeven wrote:
[...]
>>
>> Sounds reasonable, at least it can avoid the specific depends on !*arch* cruft.
>>
> 
> Thank you very much, next when I try the ARCH_MIGHT_HAVE_VGA, I shall
> process it (remove useless "screen_info").
> 

Excuse me, after some trying, I guess, at present, I am not suitable to
perform global architecture wide patches (e.g. ARCH_MIGHT_HAVE_VGA). So
welcome any other members to help try.

I guess, in the future, after I finish all architectures allmodconfig,
I shall be suitable for sending global architecture wide patches.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
