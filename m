Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaFSUUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:20:20 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53376 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbaFSUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:20:18 -0400
Date: Thu, 19 Jun 2014 13:20:14 -0700
From: josh@joshtriplett.org
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tugce Sirin <ztugcesirin@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Neil Armstrong <superna9999@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] wlan-ng/prism2sta:checkpatch: Fix string split
Message-ID: <20140619202014.GG16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-7-git-send-email-Johannes.Stadlinger@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403205620-10219-7-git-send-email-Johannes.Stadlinger@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:20:19PM +0200, Johannes Stadlinger wrote:
> This patch fixes a warning of checkpatch about string splitting.
> 
> Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> CC: linux-kernel@i4.cs.fau.de
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Tugce Sirin <ztugcesirin@gmail.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> CC: Neil Armstrong <superna9999@gmail.com>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: devel@driverdev.osuosl.org
> CC: linux-kernel@vger.kernel.org

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/wlan-ng/prism2sta.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
> index a449fdf..9444006 100644
> --- a/drivers/staging/wlan-ng/prism2sta.c
> +++ b/drivers/staging/wlan-ng/prism2sta.c
> @@ -468,8 +468,7 @@ u32 prism2sta_ifstate(wlandevice_t *wlandev, u32 ifstate)
>  			break;
>  		case WLAN_MSD_RUNNING:
>  			netdev_warn(wlandev->netdev,
> -			       "Cannot enter fwload state from enable state,"
> -			       "you must disable first.\n");
> +				    "Cannot enter fwload state from enable state, you must disable first.\n");
>  			result = P80211ENUM_resultcode_invalid_parameters;
>  			break;
>  		case WLAN_MSD_HWFAIL:
> -- 
> 1.9.1
> 
