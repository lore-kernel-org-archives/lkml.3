Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaBJFCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 00:02:19 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54194 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbaBJFCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 00:02:08 -0500
X-Sasl-enc: AS6K/iRc8FD5mSyfOY/zv1gs3dgQbAD7MaSygg9zXGA7 1392008527
Date: Sun, 9 Feb 2014 21:04:06 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20140210050406.GA15517@kroah.com>
References: <20140210155412.d42b2dda36feac3e9c8733fe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210155412.d42b2dda36feac3e9c8733fe@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:54:12PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/rtl8188eu/core/rtw_mlme.c: In function '_rtw_init_mlme_priv':
> drivers/staging/rtl8188eu/core/rtw_mlme.c:65:2: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
>   pbuf = vzalloc(MAX_BSS_CNT * (sizeof(struct wlan_network)));
>   ^

<snip>

Sorry about that.  Larry sent me a patch for this Friday evening and I
haven't had the chance to add it to my tree just yet.  Sorry for the
noise.

greg k-h
