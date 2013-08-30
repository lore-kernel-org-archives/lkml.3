Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3H3GA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:00:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40249 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab3H3GA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:00:27 -0400
X-Sasl-enc: FoRC+UU7IL/NBvunIVdGvMJtWql0/qWAJhhqw5trXcx6 1377842426
Date: Thu, 29 Aug 2013 23:02:50 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        David Graham White <dgwhite11@gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the pm tree
Message-ID: <20130830060250.GB19251@kroah.com>
References: <20130830152640.33496a2559431eb1c10b6f8e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830152640.33496a2559431eb1c10b6f8e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 03:26:40PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/core.c between commit 5e33bc4165f3 ("driver core / ACPI:
> Avoid device hot remove locking issues") from the  tree and commit
> 86df26870569 ("drivers:base:core: Moved sym export macros to respective
> functions") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Merge looks great, thanks.

greg k-h
