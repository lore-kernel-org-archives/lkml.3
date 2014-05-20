Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaETHGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:06:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55326 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbaETHGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:06:11 -0400
X-Sasl-enc: aCjvKFm5z0DTUJKM1p5Zdly5kxlzPXIJeZWDOwQNqkKj 1400569568
Date: Tue, 20 May 2014 16:06:05 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Seunghun Lee <waydi1@gmail.com>
Subject: Re: linux-next: manual merge of the dma-buf tree with the staging
 tree
Message-ID: <20140520070605.GA7961@kroah.com>
References: <20140520170031.1d27c26a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520170031.1d27c26a@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 05:00:31PM +1000, Stephen Rothwell wrote:
> Hi Sumit,
> 
> Today's linux-next merge of the dma-buf tree got a conflict in
> drivers/staging/android/sync.c between commit 10f62861b4a2 ("staging:
> android: fix missing a blank line after declarations") from the staging
> tree and commit 85958aff6184 ("android: convert sync to fence api, v5")
> from the dma-buf tree.
> 
> I fixed it up (I just used the dma-buf tree version of conflicting
> sections) and can carry the fix as necessary (no action is required).

Sounds good, thanks.

greg k-h
