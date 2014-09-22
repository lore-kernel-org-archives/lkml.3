Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaIVOb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:31:59 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59028 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318AbaIVOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:31:56 -0400
X-Sasl-enc: E1/3CXuufIvyEOm4m01i6JZZCsrJNXI3Xr+Zv5Q4nCrZ 1411396315
Date: Mon, 22 Sep 2014 07:31:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20140922143105.GA22674@kroah.com>
References: <20140922150124.4f24bb6f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922150124.4f24bb6f@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:01:24PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/iio/accel/bma180.c between commit 0668a4e4d297 ("iio: accel:
> bma180: Fix indio_dev->trig assignment") from Linus' tree and commit
> 16ed8692fa48 ("iio:bma180: Enable use of device without IRQ") from the
> staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks, the fix looks correct.

greg k-h
