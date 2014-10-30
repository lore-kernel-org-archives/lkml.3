Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbaJ3LMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:12:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208AbaJ3LMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:12:10 -0400
Date: Thu, 30 Oct 2014 12:12:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH - resend] checkpatch: Remove unnecessary + after {8,8}
Message-ID: <20141030111204.GA11295@pd.tnic>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013927.GA30781@kroah.com>
 <1405129612.6751.24.camel@joe-AO725>
 <20140712020114.GA12301@kroah.com>
 <20140712020520.GA18611@kroah.com>
 <1409590506.2614.4.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409590506.2614.4.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andrew,

can we get this one applied already - I'm seeing this warning at least
since before my summer vacation started! :-P

Thanks.

On Mon, Sep 01, 2014 at 09:55:06AM -0700, Joe Perches wrote:
> There's a useless "+" use that needs to be removed as perl 5.20
> emits a "Useless use of greediness modifier '+'" message each
> time it's hit.
> 
> Reported-by: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Resending, maybe Andrew's all-seeing eye blinked...
> 
> On Fri, 2014-07-11 at 19:05 -0700, Greg KH wrote:
> > Ok, with linux-next I get the same thing:
> 
> Thanks Greg.
> 
>  scripts/checkpatch.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index d5ac001..370a974 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2376,7 +2376,7 @@ sub process {
>  				"please, no space before tabs\n" . $herevet) &&
>  			    $fix) {
>  				while ($fixed[$fixlinenr] =~
> -					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
> +					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
>  				while ($fixed[$fixlinenr] =~
>  					   s/(^\+.*) +\t/$1\t/) {}
>  			}
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
