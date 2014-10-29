Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204AbaJ2PsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:48:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587AbaJ2Pl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:41:56 -0400
Date: Wed, 29 Oct 2014 16:37:59 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, heenasirwani@gmail.com,
        bergwolf@gmail.com, amir.shehata@intel.com, gdonald@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/02] staging:lustre:lnet:selftest: remove unused
 function
Message-ID: <20141029083759.GA23302@kroah.com>
References: <cover.1414517099.git.antonysaraev@gmail.com>
 <993d3876f1afcf5aa80ee619adde33a44c9d0416.1414517099.git.antonysaraev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <993d3876f1afcf5aa80ee619adde33a44c9d0416.1414517099.git.antonysaraev@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:50:19PM +0400, Anton Saraev wrote:
> Function lnet_selftest_structure_assertion is never used and can
> be removed.
> 
> Signed-off-by: Anton Saraev <antonysaraev@gmail.com>
> ---
>  drivers/staging/lustre/lnet/selftest/module.c | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lnet/selftest/module.c b/drivers/staging/lustre/lnet/selftest/module.c
> index 718663f..92520c2 100644
> --- a/drivers/staging/lustre/lnet/selftest/module.c
> +++ b/drivers/staging/lustre/lnet/selftest/module.c
> @@ -90,17 +90,6 @@ lnet_selftest_fini(void)
>  	return;
>  }
>  
> -static void
> -lnet_selftest_structure_assertion(void)
> -{
> -	CLASSERT(sizeof(srpc_msg_t) == 160);
> -	CLASSERT(sizeof(srpc_test_reqst_t) == 70);
> -	CLASSERT(offsetof(srpc_msg_t, msg_body.tes_reqst.tsr_concur) == 72);
> -	CLASSERT(offsetof(srpc_msg_t, msg_body.tes_reqst.tsr_ndest) == 78);
> -	CLASSERT(sizeof(srpc_stat_reply_t) == 136);
> -	CLASSERT(sizeof(srpc_stat_reqst_t) == 28);
> -}
> -
>  static int
>  lnet_selftest_init(void)
>  {

This doesn't apply to my tree at all :(
