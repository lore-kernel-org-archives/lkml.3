Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaBMJAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:00:10 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60514 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaBMJAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:00:08 -0500
MIME-Version: 1.0
In-Reply-To: <1392200311.23759.27.camel@x220>
References: <1392200311.23759.27.camel@x220>
Date: Thu, 13 Feb 2014 17:00:08 +0800
Message-ID: <CAMk6uBk+jPpDOwN6C+xkuhWB1b3EGxb205-JhnK2JZhZMvVn2w@mail.gmail.com>
Subject: Re: blackfin: Kconfig symbol VIDEO_MT9M114?
From: Steven Miao <realmz6@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Richard Weinberger <richard@nod.at>,
        adi-buildroot-devel@lists.sourceforge.net,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Feb 12, 2014 at 6:18 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Steven, Sonic,
>
> Your commit 54e4ff4d4024 ("blackfin: adi gpio driver and pinctrl driver
> support") added a check for the Kconfig macro CONFIG_VIDEO_MT9M114. That
> commit was added during the v3.13 release cycle.
>
> There's no Kconfig symbol VIDEO_MT9M114 in mainline. And it doesn't look
> like this was a typo. So why was that check added?
VIDEO_MT9M114 is from patch "Aptina mt9m114 HD digital image sensor
driver", but unfortunately this patch hasn't been accepted yet.
https://patchwork.linuxtv.org/patch/16308/
This Kconfig symbol should be removed until the mt9m114 driver is
accepted by mainline.

>
> Regards,
>
>
> Paul Bolle
>

-steven
