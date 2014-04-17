Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaDQQRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:17:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45305 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbaDQQR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:17:27 -0400
X-Sasl-enc: wy56YpMRlmuOcPlnVScTf1IVeEZRL+p/tpJJYSyQwxTd 1397751446
Date: Thu, 17 Apr 2014 09:17:32 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20140417161732.GD22187@kroah.com>
References: <20140417143137.a66d4f53a928fd454911fa50@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417143137.a66d4f53a928fd454911fa50@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:31:37PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got conflicts in
> drivers/staging/rtl8723au/core/rtw_ieee80211.c,
> drivers/staging/rtl8723au/core/rtw_mlme_ext.c,
> drivers/staging/rtl8723au/core/rtw_p2p.c and
> drivers/staging/rtl8723au/core/rtw_wlan_util.c between commit
> f5d197b614d8 ("staging: rtl8723au: Fix buffer overflow in rtw_get_wfd_ie
> ()") from the staging.current tree and various commits from the staging
> tree.
> 
> I fixed it up (I just use dthe version from the staging tree) and can
> carry the fix as necessary (no action is required).

Sounds good, thanks.

greg k-h
