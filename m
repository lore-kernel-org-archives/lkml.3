Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3HPNre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:47:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab3HPNrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:47:31 -0400
Date: Fri, 16 Aug 2013 06:49:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: cdc_ncm: Export cdc_ncm_{tx,rx}_fixup functions for
 re-use
Message-ID: <20130816134907.GA10987@kroah.com>
References: <alpine.LNX.2.02.1307021241380.8884@eeeadesso>
 <87wqp9xja5.fsf@nemi.mork.no>
 <alpine.LNX.2.02.1307101425310.22696@eeeadesso>
 <0cbf7c81-182e-493c-9c28-5b78160a08f1@email.android.com>
 <alpine.LNX.2.02.1307170457450.1161@eeeadesso>
 <87bo4xx3ef.fsf@nemi.mork.no>
 <alpine.LNX.2.02.1308161534410.23935@eeeadesso>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.02.1308161534410.23935@eeeadesso>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:39:19PM +0200, Enrico Mioso wrote:
> Some drivers implementing NCM-like protocols, may re-use those functions, as is 
> the case in the huawei_cdc_ncm driver.

Where is that driver at, I don't see it in the kernel tree.

> Export them via EXPORT_SYMBOL_GPL.

Normally we don't export symbols until code that actually uses the
symbols lands in the tree at the same time.

thanks,

greg k-h
