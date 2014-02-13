Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaBMJCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:02:54 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42310 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaBMJCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:02:49 -0500
MIME-Version: 1.0
In-Reply-To: <1392202477.23759.28.camel@x220>
References: <1392202477.23759.28.camel@x220>
Date: Thu, 13 Feb 2014 17:02:48 +0800
Message-ID: <CAMk6uB=womgrUM6SnU9sWb__J8HOpF=6DDk5fpWARQH_tEem0g@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Remove GENERIC_GPIO config option again
From: Steven Miao <realmz6@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
        "open list:CAN NETWORK DRIVERS <linux-can@vger.kernel.org>, open
	list:NETWORKING DRIVERS <netdev@vger.kernel.org>, open list" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Feb 12, 2014 at 6:54 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> The Kconfig symbol GENERIC_GPIO was removed in v3.10. Nothing cares
> about it anymore. It popped up somehow in v3.13, so it can be removed
> again.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested, but safe anyhow.
>
>  arch/blackfin/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 9ceccef..debd9df 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -51,9 +51,6 @@ config GENERIC_BUG
>  config ZONE_DMA
>         def_bool y
>
> -config GENERIC_GPIO
> -       def_bool y
> -
Applied. Thanks!

>  config FORCE_MAX_ZONEORDER
>         int
>         default "14"
> --
> 1.8.5.3
>
