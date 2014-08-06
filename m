Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaHFUNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:13:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28659 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaHFUNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:13:49 -0400
Date: Wed, 6 Aug 2014 23:13:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 05/12] staging: lustre: Add missing spaces around
 operators and braces.
Message-ID: <20140806201333.GC4856@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-5-git-send-email-srikrishanmalik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407345182-709-5-git-send-email-srikrishanmalik@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 10:42:55PM +0530, Srikrishan Malik wrote:
> diff --git a/drivers/staging/lustre/lustre/mdc/mdc_reint.c b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
> index c5420a42bc33..c40304bf0b62 100644
> --- a/drivers/staging/lustre/lustre/mdc/mdc_reint.c
> +++ b/drivers/staging/lustre/lustre/mdc/mdc_reint.c
> @@ -71,7 +71,7 @@ int mdc_resource_get_unused(struct obd_export *exp, const struct lu_fid *fid,
>  			    __u64 bits)
>  {
>  	struct ldlm_namespace *ns = exp->exp_obd->obd_namespace;
> -	ldlm_policy_data_t policy = {{0}};
> +	ldlm_policy_data_t policy = {{0} };

That's odd.  Since when is a space required here?  Anyway, put one at
the start too if you're goind to do that.  Or you could do it like:

	ldlm_policy_data_t policy = {};

?

regards,
dan carpenter

