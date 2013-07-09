Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3GIQLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:11:50 -0400
Received: from smtp-out-197.synserver.de ([212.40.185.197]:1062 "EHLO
	smtp-out-197.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3GIQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:11:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7595
Message-ID: <51DC365E.7000900@metafoo.de>
Date: Tue, 09 Jul 2013 18:12:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Cristian Bercaru <cristian.bercaru@freescale.com>
CC: linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [Cocci] [PATCH] invoke arguments the right way in coccinelle
 script
References: <1373383278-3339-1-git-send-email-cristian.bercaru@freescale.com>
In-Reply-To: <1373383278-3339-1-git-send-email-cristian.bercaru@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 05:21 PM, Cristian Bercaru wrote:
> Because the command line arguments were invoked incorrectly
> 'make coccicheck' failed to run 'irqf_oneshot.cocci' and all tests that
> followed. Fixed that.
> 
> Signed-off-by: Cristian Bercaru <cristian.bercaru@freescale.com>

Time to update your coccinelle installation ;)

--no-include is support in new versions and is prefered over -no_includes

> ---
>  scripts/coccinelle/misc/irqf_oneshot.cocci | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/coccinelle/misc/irqf_oneshot.cocci b/scripts/coccinelle/misc/irqf_oneshot.cocci
> index 6cfde94..5cca680 100644
> --- a/scripts/coccinelle/misc/irqf_oneshot.cocci
> +++ b/scripts/coccinelle/misc/irqf_oneshot.cocci
> @@ -4,7 +4,7 @@
>  //
>  // Confidence: Good
>  // Comments:
> -// Options: --no-includes
> +// Options: -no_includes
>  
>  virtual patch
>  virtual context

