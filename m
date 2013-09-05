Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553Ab3IEISt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:18:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763372Ab3IEISe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:18:34 -0400
Date: Thu, 5 Sep 2013 10:18:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: MAINTAINERS: Adding Roccat drivers 2nd
 try
In-Reply-To: <1378355761.2457.8.camel@neuromancer.tessier-ashpool>
Message-ID: <alpine.LNX.2.00.1309051018240.3684@pobox.suse.cz>
References: <1378355761.2457.8.camel@neuromancer.tessier-ashpool>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013, Stefan Achatz wrote:

> Adding maintainer for Roccat hid drivers
> 
> I sent this patch some weeks ago, seemingly unnoticed.
> Maybe I have more luck via Jiri's hid repo.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> ---
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9705318..55d946b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6921,6 +6921,14 @@ M:	Maxim Levitsky <maximlevitsky@gmail.com>
>  S:	Maintained
>  F:	drivers/memstick/host/r592.*
>  
> +ROCCAT DRIVERS
> +M:	Stefan Achatz <erazor_de@users.sourceforge.net>
> +W:	http://sourceforge.net/projects/roccat/
> +S:	Maintained
> +F:	drivers/hid/hid-roccat*
> +F:	include/linux/hid-roccat*
> +F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
> +
>  ROCKETPORT DRIVER
>  P:	Comtrol Corp.
>  W:	http://www.comtrol.com

Applied.

-- 
Jiri Kosina
SUSE Labs
