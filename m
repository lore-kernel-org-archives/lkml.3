Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaKZL51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:57:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaKZL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:57:25 -0500
Date: Wed, 26 Nov 2014 14:57:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Athira Lekshmi C V <andnlnbn18@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        gulsah.1004@gmail.com
Subject: Re: [PATCH] Drivers:staging:octeon: Fixed checkpatch warning
Message-ID: <20141126115716.GG4835@mwanda>
References: <1417002468-30711-1-git-send-email-andnlnbn18@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417002468-30711-1-git-send-email-andnlnbn18@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 05:17:48PM +0530, Athira Lekshmi C V wrote:
> @@ -294,8 +297,10 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
>  			 * CPU.
>  			 */
>  			union cvmx_pow_wq_int_cntx counts;
> +

Don't put a blank here.

>  			int backlog;
>  			int cores_in_use = core_state.baseline_cores - atomic_read(&core_state.available_cores);
> +
>  			counts.u64 = cvmx_read_csr(CVMX_POW_WQ_INT_CNTX(pow_receive_group));
>  			backlog = counts.s.iq_cnt + counts.s.ds_cnt;

regards,
dan carpenter

