Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaHKFgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:36:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40619 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbaHKFgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:36:36 -0400
X-Sasl-enc: 3e9V/fPGtoK3OzgjttTkctY8mNIHs6kQolB2nlodC4PV 1407735395
Date: Mon, 11 Aug 2014 13:36:00 +0800
From: Greg KH <greg@kroah.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark
 X1000
Message-ID: <20140811053600.GA13727@kroah.com>
References: <4656BEB6164FC34F8171C6538F1A595B2E971A2E@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E971A2E@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 05:21:50AM +0000, Chen, Alvin wrote:
> Hi Felipe,
> 
> Any update for this patch? Just want to follow-up.

It's the middle of the merge window, we can't do anything until 3.17-rc1
is out, please relax...

greg k-h
