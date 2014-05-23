Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaEWSrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:47:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaEWSre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:47:34 -0400
Date: Fri, 23 May 2014 21:38:15 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Bob Copeland <me@bobcopeland.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        Joe Perches <joe@perches.com>, Teodora Baluta <teobaluta@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>, Dave Jones <davej@redhat.com>,
        Ana Rey <anarey@gmail.com>, Xenia Ragiadakou <burzalodowa@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rui Miguel Silva <rmfrfs@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192u: Remove old WIRELESS_EXT support
Message-ID: <20140523123815.GA26412@kroah.com>
References: <1400346301-18389-1-git-send-email-joelpelaez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400346301-18389-1-git-send-email-joelpelaez@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 12:05:01PM -0500, Joel Pelaez Jorge wrote:
> Remove support for building against ancient WIRELESS_EXT versions,
> only leaving support for the current version: 22
> 
> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> ---
>  drivers/staging/rtl8192u/ieee80211/ieee80211.h    | 14 ---------
>  drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c |  5 +--
>  drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c | 38 ++---------------------
>  drivers/staging/rtl8192u/r8192U_core.c            |  6 +---
>  drivers/staging/rtl8192u/r8192U_wx.c              | 20 +-----------
>  5 files changed, 5 insertions(+), 78 deletions(-)

This doesn't apply to my tree for some reason, can you please refresh it
against the staging-next branch of the staging.git tree on
git.kernel.org and resend?

thanks,

greg k-h
