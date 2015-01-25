Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbbAYWB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:01:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbAYWB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:01:27 -0500
Date: Sun, 25 Jan 2015 14:01:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luca Olivetti <luca@ventoso.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fengguag Wu <fengguang.wu@intel.com>,
        Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 3.18 105/183] [media] af9005: fix kernel panic on init if
 compiled without IR
Message-ID: <20150125220124.GA28946@kroah.com>
References: <20150125180810.160428929@linuxfoundation.org>
 <20150125180814.764501379@linuxfoundation.org>
 <54C544EB.3000104@ventoso.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C544EB.3000104@ventoso.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 08:32:59PM +0100, Luca Olivetti wrote:
> El 25/01/15 a les 19:07, Greg Kroah-Hartman ha escrit:
> > 3.18-stable review patch.  If anyone has any objections, please let me know.
> 
> I don't have any objection apart from the description: IIRC the bug is
> triggered only if the kernel is compiled without module support.
> In any case I think that symbol_request should return NULL if the
> requested symbol is not available, either because the kernel has been
> compiled without module support or the required symbol is not provided
> by any module (though I think in the latter case it already works this
> way, at least it did at the time I wrote the driver).
> Or, as I said here
> https://lkml.org/lkml/2009/2/4/350
> maybe symbol_request isn't the correct approach to provide multiple,
> alternative, implementations.

The description is identical to what is in Linus's tree, so there's not
much I can do about it at this late point in time, sorry.

thanks,

greg k-h
