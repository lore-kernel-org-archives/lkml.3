Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaLWJhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:37:03 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52638 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLWJhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:37:00 -0500
Date: Tue, 23 Dec 2014 01:36:54 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: samuel kihahu <skihahu@gmail.com>
Cc: gregkh@linuxfoundation.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: cleanup align switch and case
Message-ID: <20141223093654.GA5208@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	samuel kihahu <skihahu@gmail.com>, gregkh@linuxfoundation.org,
	oleg.drokin@intel.com, andreas.dilger@intel.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1419321466-8068-1-git-send-email-skihahu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419321466-8068-1-git-send-email-skihahu@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

samuel,

This patch is corrupt and won't apply.  I suspect it is due to missing
spaces at the start of each line in the diff.

I recommend using 'git send-email'.  But if you are using a different
client have a look at Documentation/email-clients.txt for tips on how to
avoid these problems.

On Tue, Dec 23, 2014 at 10:57:46AM +0300, samuel kihahu wrote:
> From: samuel kihahu <skihahu@gmail.com>
> 
> Align switch and case to be at the same indent.
> 
> Signed-off-by: samuel kihahu <skihahu@gmail.com>
> ---
>  drivers/staging/lustre/lnet/selftest/module.c | 50 +++++++++++++--------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lnet/selftest/module.c b/drivers/staging/lustre/lnet/selftest/module.c
> index 6dd4309..b5f07fa 100644
> --- a/drivers/staging/lustre/lnet/selftest/module.c
> +++ b/drivers/staging/lustre/lnet/selftest/module.c
> @@ -61,31 +61,31 @@ lnet_selftest_fini(void)
> 	int	i;
> 
> 	switch (lst_init_step) {
> -		case LST_INIT_CONSOLE:
> -			lstcon_console_fini();
> -		case LST_INIT_FW:
> -			sfw_shutdown();
> -		case LST_INIT_RPC:
> -			srpc_shutdown();
> -		case LST_INIT_WI_TEST:
> -			for (i = 0;
> -			     i < cfs_cpt_number(lnet_cpt_table()); i++) {
> -				if (lst_sched_test[i] == NULL)
> -					continue;
> -				cfs_wi_sched_destroy(lst_sched_test[i]);
> -			}
> -			LIBCFS_FREE(lst_sched_test,
> -				    sizeof(lst_sched_test[0]) *
> -				    cfs_cpt_number(lnet_cpt_table()));
> -			lst_sched_test = NULL;
> -
> -		case LST_INIT_WI_SERIAL:
> -			cfs_wi_sched_destroy(lst_sched_serial);
> -			lst_sched_serial = NULL;
> -		case LST_INIT_NONE:
> -			break;
> -		default:
> -			LBUG();
> +	case LST_INIT_CONSOLE:
> +		lstcon_console_fini();
> +	case LST_INIT_FW:
> +		sfw_shutdown();
> +	case LST_INIT_RPC:
> +		srpc_shutdown();
> +	case LST_INIT_WI_TEST:
> +		for (i = 0;
> +		     i < cfs_cpt_number(lnet_cpt_table()); i++) {
> +			if (lst_sched_test[i] == NULL)
> +				continue;
> +			cfs_wi_sched_destroy(lst_sched_test[i]);
> +		}
> +		LIBCFS_FREE(lst_sched_test,
> +			    sizeof(lst_sched_test[0]) *
> +			    cfs_cpt_number(lnet_cpt_table()));
> +		lst_sched_test = NULL;
> +
> +	case LST_INIT_WI_SERIAL:
> +		cfs_wi_sched_destroy(lst_sched_serial);
> +		lst_sched_serial = NULL;
> +	case LST_INIT_NONE:
> +		break;
> +	default:
> +		LBUG();
> 	}
> 	return;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
