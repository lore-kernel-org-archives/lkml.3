Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3LNU3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:29:07 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:33569 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNU3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:29:04 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:28:58 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers: edac: Mark the function
 get_mci_for_node_id() as static in sb_edac.c
Message-ID: <20131214202857.GE17601@leaf>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
 <0441f508186fc4eeabc8e9c3e4dde013d99405d4.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0441f508186fc4eeabc8e9c3e4dde013d99405d4.1387029387.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:32:09PM +0530, Rashika Kheria wrote:
> This patch marks the function get_mci_for_node_id() as static in
> sb_edac.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in sb_edac.c:
> drivers/edac/sb_edac.c:918:22: warning: no previous prototype for ‘get_mci_for_node_id’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/edac/sb_edac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index 8472405..a8845a3 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -915,7 +915,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
>  	}
>  }
>  
> -struct mem_ctl_info *get_mci_for_node_id(u8 node_id)
> +static struct mem_ctl_info *get_mci_for_node_id(u8 node_id)
>  {
>  	struct sbridge_dev *sbridge_dev;
>  
> -- 
> 1.7.9.5
> 
