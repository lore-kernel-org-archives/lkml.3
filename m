Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbbAQXfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:35:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbbAQXfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:35:44 -0500
Date: Sat, 17 Jan 2015 15:00:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tero Marttila <tero.marttila@aalto.fi>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Luis de Bethencourt <luis@debethencourt.com>
Subject: Re: [PATCH] staging: octeon: Fix checkpatch line spacing warnings
Message-ID: <20150117230037.GA3781@kroah.com>
References: <1421080058-8871-1-git-send-email-tero.marttila@aalto.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421080058-8871-1-git-send-email-tero.marttila@aalto.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:27:38PM +0200, Tero Marttila wrote:
> Fix missing blank lines after declarations in octeon/ethernet-rx.c
> 
> Signed-off-by: Tero Marttila <tero.marttila@aalto.fi>
> ---
>  drivers/staging/octeon/ethernet-rx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index fcbe836..22667db 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -109,6 +109,7 @@ static inline int cvm_oct_check_rcv_error(cvmx_wqe_t *work)
>  		int interface = cvmx_helper_get_interface_num(work->ipprt);
>  		int index = cvmx_helper_get_interface_index_num(work->ipprt);
>  		union cvmx_gmxx_rxx_frm_ctl gmxx_rxx_frm_ctl;
> +
>  		gmxx_rxx_frm_ctl.u64 =
>  		    cvmx_read_csr(CVMX_GMXX_RXX_FRM_CTL(index, interface));
>  		if (gmxx_rxx_frm_ctl.s.pre_chk == 0) {
> @@ -214,6 +215,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
>  		did_work_request = 0;
>  		if (work == NULL) {
>  			union cvmx_pow_wq_int wq_int;
> +
>  			wq_int.u64 = 0;
>  			wq_int.s.iq_dis = 1 << pow_receive_group;
>  			wq_int.s.wq_int = 1 << pow_receive_group;
> -- 
> 1.9.1

Someone else sent this before you did, sorry :(
