Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaFLDx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:53:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaFLDx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:53:26 -0400
Date: Wed, 11 Jun 2014 20:53:19 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Nick Krause <nickkrause@sympatico.ca>
Cc: "martyn.welch@ge.com" <martyn.welch@ge.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "manohar.vanga@gmail.com" <manohar.vanga@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH[vme/bridges/vme_ca91cx42.c:1382: Bad if test Bug Fix]
Message-ID: <20140612035319.GA14993@kroah.com>
References: <SNT145-W91D1F7437CE550B912FD99A52A0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SNT145-W91D1F7437CE550B912FD99A52A0@phx.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:44:34AM +0000, Nick Krause wrote:
> Hey Fellow Developers, 
> This is my first patch so if there are any errors please reply as i will 
> fix them. Below is the patch.
> -- drivers/vme/bridges/vme_ca91cx42.h.orig    2014-06-11 22:50:29.339671939 -0400
> +++ drivers/vme/bridges/vme_ca91cx42.h    2014-06-11 23:15:36.027685173 -0400
> @@ -526,7 +526,7 @@ static const int CA91CX42_LINT_LM[] = {
>  #define CA91CX42_VSI_CTL_SUPER_SUPR    (1<<21)
>  
>  #define CA91CX42_VSI_CTL_VAS_M        (7<<16)
> -#define CA91CX42_VSI_CTL_VAS_A16    0
> +#define CA91CX42_VSI_CTL_VAS_A16    (3<<16)
>  #define CA91CX42_VSI_CTL_VAS_A24    (1<<16)
>  #define CA91CX42_VSI_CTL_VAS_A32    (1<<17)
>  #define CA91CX42_VSI_CTL_VAS_USER1    (3<<17)
> @@ -549,7 +549,7 @@ static const int CA91CX42_LINT_LM[] = {
>  #define CA91CX42_LM_CTL_SUPR        (1<<21)
>  #define CA91CX42_LM_CTL_NPRIV        (1<<20)
>  #define CA91CX42_LM_CTL_AS_M        (5<<16)
> -#define CA91CX42_LM_CTL_AS_A16        0
> +#define CA91CX42_LM_CTL_AS_A16        (3<<16)
>  #define CA91CX42_LM_CTL_AS_A24        (1<<16)
>  #define CA91CX42_LM_CTL_AS_A32        (1<<17)
> Signed-off-by: Nicholas Krause <nickkrause@sympatico.ca>

Always run your patch through scripts/checkpatch.pl first to catch the
issues that are 'obvious'.

After that, the signed-off-by: needs to be up in the changelog area,
there needs to be a changelog explaining why this patch is needed, and
the tabs need to be put back in the patch (your email client ate them.)

Can you try again?

thanks,

greg k-h
