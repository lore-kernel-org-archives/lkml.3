Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3LNU2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:28:41 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36170 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNU2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:28:40 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:28:33 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers: edac: Mark the function
 edac_create_debug_nodes() as static in edac_mc_sysfs.c
Message-ID: <20131214202833.GD17601@leaf>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
 <a1c863b08c0d6f67d03280cf908c771bf26a3239.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a1c863b08c0d6f67d03280cf908c771bf26a3239.1387029387.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:30:11PM +0530, Rashika Kheria wrote:
> This patch marks the function edac_create_debug_nodes() as static in
> edac_mc_sysfs.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in edac_mc_sysfs.c:
> drivers/edac/edac_mc_sysfs.c:917:5: warning: no previous prototype for ‘edac_create_debug_nodes’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/edac/edac_mc_sysfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
> index 9f7e0e60..51c0362 100644
> --- a/drivers/edac/edac_mc_sysfs.c
> +++ b/drivers/edac/edac_mc_sysfs.c
> @@ -914,7 +914,7 @@ void __exit edac_debugfs_exit(void)
>  	debugfs_remove(edac_debugfs);
>  }
>  
> -int edac_create_debug_nodes(struct mem_ctl_info *mci)
> +static int edac_create_debug_nodes(struct mem_ctl_info *mci)
>  {
>  	struct dentry *d, *parent;
>  	char name[80];
> -- 
> 1.7.9.5
> 
