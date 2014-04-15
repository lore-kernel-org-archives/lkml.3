Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaDOHug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:50:36 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750898AbaDOHue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:50:34 -0400
Message-ID: <534CE4C1.9010507@nod.at>
Date: Tue, 15 Apr 2014 09:50:25 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        FRAMEBUFFER LAYER <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/28] Remove CPU_PXA988
References: <1391971686-9517-1-git-send-email-richard@nod.at>		 <1391971686-9517-8-git-send-email-richard@nod.at>	 <1391984646.25855.79.camel@x220> <52F800B2.6010702@nod.at> <1397548054.1985.3.camel@x220>
In-Reply-To: <1397548054.1985.3.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.04.2014 09:47, schrieb Paul Bolle:
> Richard,
> 
> On Sun, 2014-02-09 at 23:26 +0100, Richard Weinberger wrote:
>> Am 09.02.2014 23:24, schrieb Paul Bolle:
>>> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
>>>> The symbol is an orphan, get rid of it.
>>>>
>>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>>
>>> This one first entered the tree in v3.9, with commit 59393bb94c10
>>> ("video: mmp display subsystem"). The Kconfig symbol has not yet been
>>> added.
>>
>> Thanks a lot for digging out the background info!
>> I'll add them to the commit message.
> 
> Did you ever find the time to update the commit message? If not, should
> I submit an updated version of this patch?

Sadly not.

Feel free to take this (and other related) patches over.
Thanks a lot for caring!

Thanks,
//richard
