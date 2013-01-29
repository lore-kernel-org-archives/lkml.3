Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab3A2Nj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:39:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:45078 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab3A2Njt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:39:49 -0500
Date: Tue, 29 Jan 2013 05:41:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Lan, Tianyu" <tianyu.lan@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20130129134139.GD1505@kroah.com>
References: <20130128214644.a3906eecaf9123b05216dcaf@canb.auug.org.au>
 <20130128144508.GA2997@kroah.com>
 <4CFBC02C07DA244CA19D6815A05BE6EE1BB7F5@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFBC02C07DA244CA19D6815A05BE6EE1BB7F5@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 04:03:07PM +0000, Lan, Tianyu wrote:
> I just check the commit 88bb965ed711 can not git revert smoothly. I will do it
> and send a revert patch.

Please do so, thanks.

greg k-h
