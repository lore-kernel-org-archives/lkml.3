Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3AaSR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:17:27 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:40558 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3AaSRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:17:25 -0500
Date: Thu, 31 Jan 2013 18:17:27 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 1/3] namespaces: utsname: fix wrong comment about
 clone_uts_ns()
Message-ID: <20130131181727.GB19854@mail.hallyn.com>
References: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359624512-23469-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Yuanhan Liu (yuanhan.liu@linux.intel.com):
> Fix the wrong comment about the return value of clone_uts_ns()
> 
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  kernel/utsname.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/utsname.c b/kernel/utsname.c
> index 08b197e..a47fc5d 100644
> --- a/kernel/utsname.c
> +++ b/kernel/utsname.c
> @@ -30,7 +30,7 @@ static struct uts_namespace *create_uts_ns(void)
>  /*
>   * Clone a new ns copying an original utsname, setting refcount to 1
>   * @old_ns: namespace to clone
> - * Return NULL on error (failure to kmalloc), new ns otherwise
> + * Return ERR_PTR(-ENOMEM) on error (failure to kmalloc), new ns otherwise
>   */
>  static struct uts_namespace *clone_uts_ns(struct user_namespace *user_ns,
>  					  struct uts_namespace *old_ns)
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
