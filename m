Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab3HFX6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:58:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40132 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3HFX6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:58:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Anton Vorontsov <anton@enomsg.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] MAINTAINERS: drivers/power: add entry for SmartReflex AVS drivers
References: <1375720159-13684-1-git-send-email-khilman@linaro.org>
	<2468244.h36esXYJ6h@vostro.rjw.lan>
Date: Tue, 06 Aug 2013 16:58:05 -0700
In-Reply-To: <2468244.h36esXYJ6h@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Wed, 07 Aug 2013 00:54:43 +0200")
Message-ID: <87haf2fk36.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday, August 05, 2013 09:29:19 AM Kevin Hilman wrote:
>> The SmartReflex AVS driver evolved out of the OMAP kernel and now
>> lives under drivers/power/avs.
>> 
>> I've historically been maintainer of this but Nishanth Menon is doing
>> most of the heavy lifting now.  Add us both as co-maintainers.
>> 
>> Cc: Anton Vorontsov <anton@enomsg.org>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>
> Who's supposed to take this patch?

I assumed Anton, but I wasn't sure since I've been merging
drivers/power/avs patches through you.

Kevin
