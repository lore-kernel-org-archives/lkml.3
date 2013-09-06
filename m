Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002Ab3IFKCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:02:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3IFKCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:02:22 -0400
Message-ID: <5229A828.7090001@suse.cz>
Date: Fri, 06 Sep 2013 12:02:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kconfig: do not special-case 'MODULES' symbol
References: <1378242287-12759-1-git-send-email-yann.morin.1998@free.fr> <5228510C.1020906@suse.cz> <20130906094715.GD3271@free.fr>
In-Reply-To: <20130906094715.GD3271@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.9.2013 11:47, Yann E. MORIN wrote:
> Michal, All,
> 
> On 2013-09-05 11:38 +0200, Michal Marek spake thusly:
>> On 3.9.2013 23:04, Yann E. MORIN wrote:
>>> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
>>>
>>> Currently, the 'MODULES' symbol is hard-coded to be the default symbol
>>> that enables/disables tristates, if no other symbol was declared with
>>> 'option modules'.
>>>
>>> While this used to be needed for the Linux kernel, we now have an
>>> explicit 'option modules' attached to the 'MODULES' symbol (since
>>> cset 11097a036), so we no longer need to special-case it in the
>>> kconfig code.
>>>
>>> Furthermore, kconfig is extensively used out of the Linux kernel, and
>>> other projects may have another meaning for a symbol named 'MODULES'.
>>>
>>> This patch changes the way we enable/disable tristates: if a symbol was
>>> found with 'option modules' attached to it, then that symbol controls
>>> enabling tristates. Otherwise, tristates are disabled, even if a symbol
>>> named 'MODULES' exists.
>>
>> Wasn't this change supposed to fix allmodconfig with KCONFIG_ALLCONFIG
>> (http://lkml.org/lkml/2013/8/8/573)? Or is there still more to do?
> 
> This is part of the fix, and there are still things to change, yes.
>
> I'm not done with it yet, since I was unavailable for some time, and I
> just wanted this part to be reviewed/upstreamed before continuing, just
> in case I was going the wrong way.

Understood. I will merge this series now and send the whole branch to
Linus later.


> I'll be further working on this, and hope to have something at the
> beginning of next week.

OK, thanks!

Michal

