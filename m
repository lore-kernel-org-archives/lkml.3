Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaIEJrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:47:49 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35879 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbaIEJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:47:47 -0400
Date: Fri, 5 Sep 2014 15:17:27 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING - INDUSTR..." <linux-iio@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: iio: adc: mxs-lradc.c: sparse warning of
 incorrect type
Message-ID: <20140905094727.GA23333@sudip-PC>
References: <1409849142-12185-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140905093413.GJ6600@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905093413.GJ6600@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 12:34:13PM +0300, Dan Carpenter wrote:
> On Thu, Sep 04, 2014 at 10:15:42PM +0530, Sudip Mukherjee wrote:
> > fixed sparse warning : incorrect type in argument 1 
> > 		       (different address spaces)
> > 
> 
> The change log is not clear.  It's the IS_ERR() which is the problem?
> This is a false positive which is fixed in a later version of Sparse.
> 
> regards,
> dan carpenter
> 
> 
yes , problem with sparse. ubuntu repo was not having the latest version , 
    and i did not check what is the latest . 
    sorry for it.

thanks
sudip
