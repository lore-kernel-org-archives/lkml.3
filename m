Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbaFSUMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:12:12 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43293 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaFSUMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:12:10 -0400
Date: Thu, 19 Jun 2014 13:12:03 -0700
From: josh@joshtriplett.org
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] wlan-ng/prism2mib:checkpatch: Fix string split
Message-ID: <20140619201202.GC16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-4-git-send-email-Johannes.Stadlinger@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403205620-10219-4-git-send-email-Johannes.Stadlinger@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:20:16PM +0200, Johannes Stadlinger wrote:
> This patch fixes a warning of checkpatch about string splitting.
> 
> Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> CC: linux-kernel@i4.cs.fau.de
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> CC: Himangi Saraogi <himangi774@gmail.com>
> CC: devel@driverdev.osuosl.org
> CC: linux-kernel@vger.kernel.org

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/wlan-ng/prism2mib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
> index 0fb42df..bdd3b4c 100644
> --- a/drivers/staging/wlan-ng/prism2mib.c
> +++ b/drivers/staging/wlan-ng/prism2mib.c
> @@ -672,8 +672,8 @@ static int prism2mib_fragmentationthreshold(struct mibrec *mib,
>  
>  	if (!isget)
>  		if ((*uint32) % 2) {
> -			netdev_warn(wlandev->netdev, "Attempt to set odd number "
> -			       "FragmentationThreshold\n");
> +			netdev_warn(wlandev->netdev,
> +				    "Attempt to set odd number FragmentationThreshold\n");
>  			msg->resultcode.data =
>  			    P80211ENUM_resultcode_not_supported;
>  			return 0;
> -- 
> 1.9.1
> 
