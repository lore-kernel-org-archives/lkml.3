Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaIHTkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:40:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaIHTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:40:04 -0400
Date: Mon, 8 Sep 2014 12:40:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Spencer Baugh <sbaugh@andrew.cmu.edu>
Cc: Oleg Drokin <oleg.drokin@intel.com>, Niu Yawei <yawei.niu@intel.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] staging: lustre: fix function definition style
Message-ID: <20140908194003.GA13205@kroah.com>
References: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410025111-31422-1-git-send-email-sbaugh@andrew.cmu.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 01:38:27PM -0400, Spencer Baugh wrote:
> Fix errors reported by checkpatch of this kind:
> ERROR: open brace '{' following function declarations go on the next line
> 
> Signed-off-by: Spencer Baugh <sbaugh@andrew.cmu.edu>
> ---
>  drivers/staging/lustre/lustre/include/lustre_import.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/lustre_import.h b/drivers/staging/lustre/lustre/include/lustre_import.h
> index 8304a55..feb4291 100644
> --- a/drivers/staging/lustre/lustre/include/lustre_import.h
> +++ b/drivers/staging/lustre/lustre/include/lustre_import.h
> @@ -346,21 +346,24 @@ static inline unsigned int at_timeout2est(unsigned int val)
>  	return (max((val << 2) / 5, 5U) - 4);
>  }
>  
> -static inline void at_reset(struct adaptive_timeout *at, int val) {
> +static inline void at_reset(struct adaptive_timeout *at, int val) 

You are adding whitespace errors with this patch, I can't take this
series because of this :(

Please always run your patches through scripts/checkpatch.pl to ensure
you aren't adding new problems.

Can you fix this series of patches up and resend?

thanks,

greg k-h
