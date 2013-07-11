Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3GKSqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:46:55 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:36895 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3GKSqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:46:51 -0400
Date: Thu, 11 Jul 2013 13:46:44 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: Fix references to defunct
 linux-net@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, trivial@kernel.org
References: <1373358151-26161-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1373358151-26161-1-git-send-email-geert@linux-m68k.org> (from
	geert@linux-m68k.org on Tue Jul  9 03:22:31 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1373568404.27613.43@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:22:31 AM, Geert Uytterhoeven wrote:
> linux-net@vger.kernel.org was replaced by netdev@oss.sgi.com was  
> replaced
> by netdev@vger.kernel.org.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Confirmed http://vger.kernel.org/vger-lists.html does not mention  
linux-net anymore.

Acked-by: Rob Landley <rob@landley.net>

Adding trivial@ to the cc:

Rob

> ---
>  Documentation/networking/arcnet.txt |    7 ++++---
>  Documentation/networking/vortex.txt |    2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/arcnet.txt  
> b/Documentation/networking/arcnet.txt
> index 9ff5795..aff97f4 100644
> --- a/Documentation/networking/arcnet.txt
> +++ b/Documentation/networking/arcnet.txt
> @@ -70,9 +70,10 @@ list, mail to linux-arcnet@tichy.ch.uj.edu.pl.
>  There are archives of the mailing list at:
>  	http://epistolary.org/mailman/listinfo.cgi/arcnet
> 
> -The people on linux-net@vger.kernel.org have also been known to be  
> very
> -helpful, especially when we're talking about ALPHA Linux kernels  
> that may or
> -may not work right in the first place.
> +The people on linux-net@vger.kernel.org (now defunct, replaced by
> +netdev@vger.kernel.org) have also been known to be very helpful,  
> especially
> +when we're talking about ALPHA Linux kernels that may or may not  
> work right
> +in the first place.
> 
> 
>  Other Drivers and Info
> diff --git a/Documentation/networking/vortex.txt  
> b/Documentation/networking/vortex.txt
> index b4038ff..9a8041d 100644
> --- a/Documentation/networking/vortex.txt
> +++ b/Documentation/networking/vortex.txt
> @@ -359,7 +359,7 @@ steps you should take:
>  - OK, it's a driver problem.
> 
>     You need to generate a report.  Typically this is an email to the
> -   maintainer and/or linux-net@vger.kernel.org.  The maintainer's
> +   maintainer and/or netdev@vger.kernel.org.  The maintainer's
>     email address will be in the driver source or in the MAINTAINERS  
> file.
> 
>  - The contents of your report will vary a lot depending upon the
> --
> 1.7.9.5
> 
> 

