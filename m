Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3GYKqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:46:38 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62552 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755641Ab3GYKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:46:34 -0400
Message-ID: <1374749192.29835.48.camel@x61.thuisdomein>
Subject: Re: [PATCH] mtd: remove obsolete JEDEC mapping drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Thu, 25 Jul 2013 12:46:32 +0200
In-Reply-To: <1368456039.1350.53.camel@x61.thuisdomein>
References: <1368456039.1350.53.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2013 10:46:32.0560 (UTC) FILETIME=[3A05A700:01CE8924]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 16:40 +0200, Paul Bolle wrote:
> JEDEC device support was removed in v2.6.22. (It had been marked as
> BROKEN (indirectly) since at least v2.6.12.)
> 
> When it was removed the two JEDEC mapping drivers that depended on it
> should have been removed too. Do so now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) These two [seem] to have been missed in Artem's recent cleaning up
> effort. Or is a comparable patch queued somewhere?

Did anyone had a chance to look at this patch? Or has this code already
been removed?

>  drivers/mtd/maps/Kconfig        |  18 ---
>  drivers/mtd/maps/Makefile       |   2 -
>  drivers/mtd/maps/octagon-5066.c | 246 ----------------------------------------
>  drivers/mtd/maps/vmax301.c      | 196 --------------------------------
>  4 files changed, 462 deletions(-)
>  delete mode 100644 drivers/mtd/maps/octagon-5066.c
>  delete mode 100644 drivers/mtd/maps/vmax301.c

[...]


Paul Bolle

