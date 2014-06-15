Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaFOJb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 05:31:26 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:41059 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaFOJbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 05:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140615112042.4e72c1f8@canb.auug.org.au>
References: <1946020.rieJTheGae@vostro.rjw.lan>
	<1402759929-15418-1-git-send-email-sre@kernel.org>
	<20140615112042.4e72c1f8@canb.auug.org.au>
Date: Sun, 15 Jun 2014 13:31:24 +0400
Message-ID: <CALT56yP-iFHq4o633r0_nYZAd0E3rBsOSLNzxfhvnfSm4FqGJg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: power_supply: update maintainership
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sebastian Reichel <sre@kernel.org>, Sebastian Reichel <sre@ring0.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jun 15, 2014 at 5:20 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Sebastian,
>
> On Sat, 14 Jun 2014 17:32:09 +0200 Sebastian Reichel <sre@kernel.org> wrote:
>>
>> Take over maintanence for orphaned power supply subsystem
>> and move the git tree to a new kernel.org based repository.
>>
>> Signed-off-by: Sebastian Reichel <sre@kernel.org>
>> ---
>> Hi,
>>
>> As suggested by Rafael in [0] I volunteer to take over the orphaned
>> power supply subsystem.
>>
>> [0] http://www.spinics.net/lists/kernel/msg1744793.html
>>
>>  POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
>> -M:   Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> -M:   David Woodhouse <dwmw2@infradead.org>
>> -T:   git git://git.infradead.org/battery-2.6.git
>
> OK, the master branch of that tree is in linux-next as the "battery"
> tree.  My contact for that tree is Anton Vorontsov (cc'd) and its
> latest commit is from January.  So should I dump that tree in favour of
> the one below with you as the contact?  If so, whatr branch of that
> tree should I fetch?  (And should I change its linux-next name?)

Not at this point, we will reconsider after -rc1.

>
>> +M:   Sebastian Reichel <sre@kernel.org>
>> +T:   git git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
With best wishes
Dmitry
