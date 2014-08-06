Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaHFUPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:15:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30230 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaHFUPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:15:19 -0400
Date: Wed, 6 Aug 2014 23:15:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] staging: lustre: replace c99 style comments with
 C89
Message-ID: <20140806201506.GD4856@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-6-git-send-email-srikrishanmalik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407345182-709-6-git-send-email-srikrishanmalik@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 10:42:56PM +0530, Srikrishan Malik wrote:
> diff --git a/drivers/staging/lustre/lustre/mdc/mdc_lib.c b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
> index 35ce2fdf696c..7f9b6eb51860 100644
> --- a/drivers/staging/lustre/lustre/mdc/mdc_lib.c
> +++ b/drivers/staging/lustre/lustre/mdc/mdc_lib.c
> @@ -416,9 +416,9 @@ void mdc_link_pack(struct ptlrpc_request *req, struct md_op_data *op_data)
>  	LASSERT(rec != NULL);
>  
>  	rec->lk_opcode   = REINT_LINK;
> -	rec->lk_fsuid    = op_data->op_fsuid;//current->fsuid;
> -	rec->lk_fsgid    = op_data->op_fsgid;//current->fsgid;
> -	rec->lk_cap      = op_data->op_cap;//current->cap_effective;
> +	rec->lk_fsuid    = op_data->op_fsuid; /* current->fsuid; */
> +	rec->lk_fsgid    = op_data->op_fsgid; /*current->fsgid; */
> +	rec->lk_cap      = op_data->op_cap;   /*current->cap_effective; */


Put a space after the '/*'.

regards,
dan carpenter


