Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaENL5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:57:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20254 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaENL5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:57:30 -0400
Date: Wed, 14 May 2014 14:57:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Denis Pithon <denis.pithon@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        himangi774@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging/wlan-ng: replace printk() with pr_xxx()
Message-ID: <20140514115715.GH22735@mwanda>
References: <1399908167-19271-1-git-send-email-denis.pithon@gmail.com>
 <1399908167-19271-4-git-send-email-denis.pithon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399908167-19271-4-git-send-email-denis.pithon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 05:22:47PM +0200, Denis Pithon wrote:
> @@ -684,8 +685,9 @@ static int p80211knetdev_set_mac_address(netdevice_t *dev, void *addr)
>  	 * change the netdev address
>  	 */
>  	if (result != 0 || resultcode->data != P80211ENUM_resultcode_success) {
> -		printk(KERN_ERR
> -		       "Low-level driver failed dot11req_mibset(dot11MACAddress).\n");
> +		pr_err(
> +		  "Low-level driver failed dot11req_mibset(dot11MACAddress)\n"
> +		);
>  		result = -EADDRNOTAVAIL;
>  	} else {
>  		/* everything's ok, change the addr in netdev */

This is fine, but in the future, just go over the 80 character limit
instead of doing the unusual line break.

regards,
dan carpenter

