Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab3G0UDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 16:03:36 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:56283 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3G0UDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 16:03:34 -0400
MIME-Version: 1.0
In-Reply-To: <1374749192.29835.48.camel@x61.thuisdomein>
References: <1368456039.1350.53.camel@x61.thuisdomein>
	<1374749192.29835.48.camel@x61.thuisdomein>
Date: Sat, 27 Jul 2013 13:03:33 -0700
Message-ID: <CAN8TOE8+NawARNOAzYjUV7OL+2JLnNJ3673_Zq9N9fkF+a5rPQ@mail.gmail.com>
Subject: Re: [PATCH] mtd: remove obsolete JEDEC mapping drivers
From: Brian Norris <computersforpeace@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 3:46 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Mon, 2013-05-13 at 16:40 +0200, Paul Bolle wrote:
>> JEDEC device support was removed in v2.6.22. (It had been marked as
>> BROKEN (indirectly) since at least v2.6.12.)
>>
>> When it was removed the two JEDEC mapping drivers that depended on it
>> should have been removed too. Do so now.
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) Untested.
>>
>> 1) These two [seem] to have been missed in Artem's recent cleaning up
>> effort. Or is a comparable patch queued somewhere?

I don't believe there is any patch queued up. (The best source for
queued MTD patches is in l2-mtd.git, by the way. See:
http://git.infradead.org/)

> Did anyone had a chance to look at this patch? Or has this code already
> been removed?

Artem has been mostly off the radar for a while, and he's mostly been
responsible for picking up patches like this. But FWIW:

Acked-by: Brian Norris <computersforpeace@gmail.com>

>>  drivers/mtd/maps/Kconfig        |  18 ---
>>  drivers/mtd/maps/Makefile       |   2 -
>>  drivers/mtd/maps/octagon-5066.c | 246 ----------------------------------------
>>  drivers/mtd/maps/vmax301.c      | 196 --------------------------------
>>  4 files changed, 462 deletions(-)
>>  delete mode 100644 drivers/mtd/maps/octagon-5066.c
>>  delete mode 100644 drivers/mtd/maps/vmax301.c

Brian
