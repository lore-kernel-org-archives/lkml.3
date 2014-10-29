Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356AbaJ2QHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:07:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955AbaJ2QHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:07:03 -0400
Date: Thu, 30 Oct 2014 00:05:53 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikael Svantesson <mikael@distopic.net>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Jake Edge <jake@lwn.net>, Anton Saraev <antonysaraev@gmail.com>
Subject: Re: [PATCH v2] staging: skein: skein_api.c: removed space before ','
Message-ID: <20141029160553.GB18125@kroah.com>
References: <544FF764.7090003@distopic.net>
 <20141029052517.GA3556@sudip-PC>
 <5450941F.5040609@distopic.net>
 <5450966A.20709@distopic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5450966A.20709@distopic.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 08:25:30AM +0100, Mikael Svantesson wrote:
> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
> ---
>  drivers/staging/skein/skein_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
> index 6e700ee..5bfce07 100644
> --- a/drivers/staging/skein/skein_api.c
> +++ b/drivers/staging/skein/skein_api.c
> @@ -31,7 +31,7 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
>  {
>  	skein_assert_ret(ctx && size, SKEIN_FAIL);
>  
> -	memset(ctx , 0, sizeof(struct skein_ctx));
> +	memset(ctx, 0, sizeof(struct skein_ctx));
>  	ctx->skein_size = size;
>  
>  	return SKEIN_SUCCESS;
> -- 
> 2.1.1
> 
> On 2014-10-29 08:15, Mikael Svantesson wrote:
> > I'm saving the patch to my mail server using git-imap-send, then enter
> > e-mail addresses using Thunderbird and send it.
> > 
> > The problem seems to be that Thunderbird thrashes empty lines when
> > double clicking the e-mail in Drafts or selecting "Edit as new".
> > When forwarding the e-mail it doesn't seem to affect the empty lines,
> > very weird behaviour.
> > 
> > Regards,
> > 
> > Mikael
> > 
> > On 2014-10-29 06:25, Sudip Mukherjee wrote:
> >> On Tue, Oct 28, 2014 at 09:07:00PM +0100, Mikael Svantesson wrote:
> >>> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
> >> still the same problem.
> >>
> >> ERROR: patch seems to be corrupt (line wrapped?)
> >>
> >>
> >>> ---
> >>>  drivers/staging/skein/skein_api.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/staging/skein/skein_api.c b/drivers/staging/skein/skein_api.c
> >>> index 6e700ee..5bfce07 100644
> >>> --- a/drivers/staging/skein/skein_api.c
> >>> +++ b/drivers/staging/skein/skein_api.c
> >>> @@ -31,7 +31,7 @@ int skein_ctx_prepare(struct skein_ctx *ctx, enum skein_size size)
> >>>  {
> >>>  	skein_assert_ret(ctx && size, SKEIN_FAIL);
> >>>  -	memset(ctx , 0, sizeof(struct skein_ctx));
> >>> +	memset(ctx, 0, sizeof(struct skein_ctx));
> >>>  	ctx->skein_size = size;
> >>>   	return SKEIN_SUCCESS;
> >>> -- 
> >>> 2.1.1
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> Please read the FAQ at  http://www.tux.org/lkml/
> > 

Please send this as a "correct" patch, not one with a whole bunch of
other stuff in it that I would have to hand-edit in order to apply
properly.

Remember, you want to make it as easy as possible for me to accept your
patches, so far, this isn't going well :)

greg k-h
