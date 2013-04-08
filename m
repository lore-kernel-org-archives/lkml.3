Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596Ab3DHSYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:24:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54121 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935284Ab3DHSYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130408172233.GA26206@kroah.com>
References: <1365385640-10443-1-git-send-email-turtle.on.the.radio@gmail.com>
	<20130408172233.GA26206@kroah.com>
Date: Mon, 8 Apr 2013 14:24:12 -0400
Message-ID: <CAC-25o9wUGRAjaO1jEbRB9AdwT7sgGcH2M2oyh4-rSyoCiSm7Q@mail.gmail.com>
Subject: Re: [PATCH] Staging: omap-thermal: remove trailing whitespace from omap-bandgap.c
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tyrel Datwyler <turtle.on.the.radio@gmail.com>, eduardo.valentin@ti.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing to right email address.

On Mon, Apr 8, 2013 at 1:22 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sun, Apr 07, 2013 at 06:47:20PM -0700, Tyrel Datwyler wrote:
>> This patch removes trailing whitespace from a blank line in omap-bandgap.c as
>> detected by the checkpatch.pl tool.
>>
>> Signed-off-by: Tyrel Datwyler <turtle.on.the.radio@gmail.com>
>> ---
>>  drivers/staging/omap-thermal/omap-bandgap.c | 2 +-
>
> This file no longer is in my tree, are you sure you made this against
> the proper branch?  Please always make staging patches against the
> linux-next tree.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Eduardo Bezerra Valentin
