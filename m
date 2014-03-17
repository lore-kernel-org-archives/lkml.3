Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaCQS2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:28:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41856 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948AbaCQS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:28:10 -0400
X-Sasl-enc: LVFo7nHpEncfHhD1/lMejPrSQJEsCS9nLckntLIAfP7s 1395080889
Date: Mon, 17 Mar 2014 11:30:10 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Zhao, Gang" <gamerh2o@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the net-next
 tree
Message-ID: <20140317183010.GB10565@kroah.com>
References: <20140317190842.795b9d29db9a131a9cff91a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317190842.795b9d29db9a131a9cff91a9@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 07:08:42PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/wlan-ng/cfg80211.c between commit 3ead0d2e220e ("wlan-ng:
> fixup staging driver for removal of ieee80211_dsss_chan_to_freq") from
> the net-next tree and commit 4e5e9d7c66f0 ("staging: wlan-ng: replace
> function ieee80211_dsss_chan_to_freq()") from the staging tree.
> 
> I fixed it up (I used the staging tree version) and can carry the fix as
> necessary (no action is required).

Thanks, that sounds correct.

greg k-h
