Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaAPCdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:33:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48576 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbaAPCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:33:09 -0500
X-Sasl-enc: VNyh3zkfWeAqevAnTODWo6eCh9QXky8+aIlBga3X7ZpP 1389839588
Date: Wed, 15 Jan 2014 18:33:37 -0800
From: GregKH <greg@kroah.com>
To: David Fries <david@fries.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/16] hold bus_mutex in netlink and search
Message-ID: <20140116023337.GA31701@kroah.com>
References: <1388299556-12669-1-git-send-email-David@Fries.net>
 <20140115045200.GA29560@spacedout.fries.net>
 <8351389819482@web5j.yandex.ru>
 <20140115211057.GH27675@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115211057.GH27675@spacedout.fries.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 03:10:57PM -0600, David Fries wrote:
> That's 1 through 14, and 16.  Patch 15 was in my tree from another developer,
> "drivers/w1/masters/w1-gpio.c: add strong pullup emulation"
> and wasn't included in what I submitted.  Should I repost the series
> in sequence?

Please resend what hasn't been taken.  It will have to wait for after
3.14-rc1 as my trees are closed at the moment until that comes out.

thanks,

greg k-h
