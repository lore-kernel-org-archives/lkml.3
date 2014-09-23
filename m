Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaIWJvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:51:08 -0400
Received: from 80-229-23-162.plus.com ([80.229.23.162]:38803 "EHLO
	mail.einon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaIWJvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:51:06 -0400
Date: Tue, 23 Sep 2014 10:50:04 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
Message-ID: <20140923095004.GB5130@leicester.auvation.com>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
 <1411437445.2952.61.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411437445.2952.61.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:57:25PM -0700, Joe Perches wrote:
> On Mon, 2014-09-22 at 22:28 +0100, Mark Einon wrote:
> > This patch moves the et131x gigabit ethernet driver from drivers/staging
> > to drivers/net/ethernet/agere.
> > 
> > There are no known issues at this time.
> 
> This doesn't apply to -next or -linux

Hi Joe,

Thanks for the review.

Yes, there are a further (minor) 8 patches by me on the driver-devel
list that are needed that this patch is based upon, as per my comment
below. As the merge window is close, I've put this out an an RFC to
get feedback ASAP.

> 
> []
> > This patch will only apply once the last few pending changes
> > make their way from staging-next to linux-next, but posting
> > now in the hope that feedback can be given and this change can
> > make it in before the next merge window.n yo
> 
> When you do post the actual patch, can you please use
> "git format-patch -M" so that the patch is significantly
> smaller and the renames are obvious?

Will do, thanks.

Mark

