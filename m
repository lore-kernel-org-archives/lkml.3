Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab3CCKOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 05:14:16 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:64376 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab3CCKOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 05:14:15 -0500
Message-ID: <1362305650.1334.24.camel@x61.thuisdomein>
Subject: Re: [PATCH 11/14] MAINTAINERS: fix BAST
From: Paul Bolle <pebolle@tiscali.nl>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Ben Dooks <ben-linux@fluff.org>,
        Simtec Linux Team <linux@simtec.co.uk>
Date: Sun, 03 Mar 2013 11:14:10 +0100
In-Reply-To: <1362275632-20242-12-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
	 <1362275632-20242-12-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2013 10:14:11.0202 (UTC) FILETIME=[D965EE20:01CE17F7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Stripped Vincent's bouncing address.]

On Sat, 2013-03-02 at 22:53 -0300, Cesar Eduardo Barros wrote:
> These files were renamed by commit 85fd6d6 (ARM: S3C2410: move
> mach-s3c2410/* into mach-s3c24xx/).
> 
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Vincent Sanders <vince@simtec.co.uk>
> Cc: Simtec Linux Team <linux@simtec.co.uk>
> Cc: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5cb888a..b73c00d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7119,9 +7119,9 @@ P:	Vincent Sanders <vince@simtec.co.uk>
>  M:	Simtec Linux Team <linux@simtec.co.uk>
>  W:	http://www.simtec.co.uk/products/EB2410ITX/
>  S:	Supported
> -F:	arch/arm/mach-s3c2410/mach-bast.c
> -F:	arch/arm/mach-s3c2410/bast-ide.c
> -F:	arch/arm/mach-s3c2410/bast-irq.c
> +F:	arch/arm/mach-s3c24xx/mach-bast.c
> +F:	arch/arm/mach-s3c24xx/bast-ide.c
> +F:	arch/arm/mach-s3c24xx/bast-irq.c
>  
>  TI DAVINCI MACHINE SUPPORT
>  M:	Sekhar Nori <nsekhar@ti.com>

This patch looks technically correct. Applying it won't hurt anyone. But
nothing has changed since yesterday's discussion. I still suggest to
remove this entry entirely.


Paul Bolle

