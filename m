Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3LPKuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:50:15 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44712 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3LPKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:50:13 -0500
X-IronPort-AV: E=Sophos;i="4.95,494,1384300800"; 
   d="scan'208";a="82576510"
Message-ID: <1387191010.20076.66.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v2 9/9] drivers: net: Mark function
 xenvif_count_frag_slots() as static in netback.c
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Wei Liu <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <josh@joshtriplett.org>
Date: Mon, 16 Dec 2013 10:50:10 +0000
In-Reply-To: <609db9fcc843525f9ca2f18673744cad2fb9fb8c.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
	 <609db9fcc843525f9ca2f18673744cad2fb9fb8c.1386911124.git.rashika.kheria@gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-14 at 18:02 +0530, Rashika Kheria wrote:
> This patch marks the function xenvif_count_frag_slots() in netback.c as
> static because they are not used outside this file.
> 
> Thus, it also removes the following warning in xen-netback/netback.c:
> drivers/net/xen-netback/netback.c:218:14: warning: no previous prototype for ‘xenvif_count_frag_slots’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
> 
> This revision fixes the following issues of the previous revision:
> Change commit message subject
> 
>  drivers/net/xen-netback/netback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 64f0e0d..9e4f399 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -215,7 +215,7 @@ struct xenvif_count_slot_state {
>  	bool head;
>  };
>  
> -unsigned int xenvif_count_frag_slots(struct xenvif *vif,
> +static unsigned int xenvif_count_frag_slots(struct xenvif *vif,
>  				     unsigned long offset, unsigned long size,
>  				     struct xenvif_count_slot_state *state)
>  {


