Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaGQJqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:46:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36066 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbaGQJqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:46:53 -0400
Date: Thu, 17 Jul 2014 11:46:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH v3 2/6] acerhdf: Adding support for new models
Message-ID: <20140717094648.GB23869@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
 <1399139966-10625-3-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399139966-10625-3-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 07:59:22PM +0200, Peter Feuerer wrote:
> added following new models:
>    * Aspire 5755G
>    * AO521
>    * AO751h
>    * Aspire One 753
>    * Extensa 5420
>    * Aspire 5315
>    * Aspire 5739G
>    * TravelMate TM8573T
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Peter Feuerer <peter@piie.net>

Acked-by: Borislav Petkov <bp@suse.de>

> ---
>  drivers/platform/x86/acerhdf.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index dd63e93..176edbd 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -50,7 +50,7 @@
>   */
>  #undef START_IN_KERNEL_MODE
>  
> -#define DRV_VER "0.5.29"
> +#define DRV_VER "0.5.30"

What's the logic here, increment second minor version number after each
change?

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
