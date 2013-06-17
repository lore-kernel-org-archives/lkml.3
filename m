Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3FQT6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:58:21 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38400 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab3FQT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:58:19 -0400
X-Sasl-enc: Hi5Wiu2+IfZvLqvgxi9KHzGQZz+z4chYkmOBn920tCQm 1371499097
Date: Mon, 17 Jun 2013 12:58:16 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Libo Chen <clbchenlibo.chen@huawei.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 devicetree tree
Message-ID: <20130617195816.GA28980@kroah.com>
References: <20130617153302.abd2024c094b8899904acb12@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617153302.abd2024c094b8899904acb12@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 03:33:02PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> include/linux/platform_device.h between commit 10dbc5e39a60 ("driver
> core: move to_platform_driver to platform_device.h") from the devicetree
> tree and commit 9447057eaff8 ("platform_device: use a macro instead of
> platform_driver_register") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Fix looks good to me, thanks.

greg k-h
