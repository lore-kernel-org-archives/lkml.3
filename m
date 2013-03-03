Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3CCWlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:41:35 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42842 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab3CCWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:41:34 -0500
X-Sasl-enc: 6S3lAu3TCuJpU/AJkMb08qXFG7gpGW2vHC48dz0RYeOF 1362350493
Date: Mon, 4 Mar 2013 06:41:50 +0800
From: GregKH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Marcin Jurkowski <marcin1j@gmail.com>,
        Sven Geggus <lists@fuchsschwanzdomain.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] w1: fix oops when w1_search is called from netlink
 connector
Message-ID: <20130303224150.GA22048@kroah.com>
References: <20130116141627.GA23638@ioremap.net>
 <20130302001103.GB18026@gmail.com>
 <20130302094510.GA4695@geggus.net>
 <20130302135015.GA21448@gmail.com>
 <20130303205452.GA2064@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130303205452.GA2064@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 12:54:52AM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> Marcin, thanks a lot for the fix, I have to sorry I'm not on this bug yet :(
> Sven confirmed patch fixes it, Greg please pull it into your tree.

Ok, will do once 3.9-rc1 is out.

thanks,

greg k-h
