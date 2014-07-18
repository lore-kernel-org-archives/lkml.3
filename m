Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbaGRDIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:08:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58604 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731AbaGRDIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:08:43 -0400
X-Sasl-enc: mrK+WTNVSyU86m7Hoa7UvexjSD2cN5QEXDAqZjn4kSyK 1405652922
Date: Thu, 17 Jul 2014 20:08:41 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
Message-ID: <20140718030841.GB13619@kroah.com>
References: <20140716032655.GB30412@kroah.com>
 <53C705DB.3040700@codeaurora.org>
 <20140717053347.GB22970@kroah.com>
 <7228146.FsqiNq1Vpj@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7228146.FsqiNq1Vpj@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:17:00PM +0200, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 22:33:47 Greg KH wrote:
> > + mmc: Char SDIO Device Driver
> 
> A few comments on the ioctl interface, since I suppose we'll have
> to live with that once it gets merged.

Thanks for the review comments.  I'll come back to this in a week or so
when I get more cycles to spend on the driver, it's _way_ down my list
of priorities at the moment.

greg k-h
