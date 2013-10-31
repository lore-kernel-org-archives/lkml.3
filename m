Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3JaWO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 18:14:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50899 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761Ab3JaWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 18:14:26 -0400
X-Sasl-enc: +B/yLSq0/wkpspwtjFQEiOyB3pRGuIcDAdXRkYFExhqc 1383257665
Date: Thu, 31 Oct 2013 15:16:28 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the  tree
Message-ID: <20131031221628.GA3595@kroah.com>
References: <20131028230152.46d44ec81ac368fa00191225@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028230152.46d44ec81ac368fa00191225@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:01:52PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/Kconfig between commit 12cc4b3827f8 ("PowerCap: Add to drivers
> Kconfig and Makefile") from the pm tree and commit ff764963479a
> ("drivers: phy: add generic PHY framework") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks fine to me, thanks.

greg k-h
