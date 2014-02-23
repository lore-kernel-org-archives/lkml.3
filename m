Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaBWE3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 23:29:36 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:41021 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaBWE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 23:29:34 -0500
Date: Sat, 22 Feb 2014 23:29:29 -0500
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Hurley <peter@hurleysoftware.com>, laijs@cn.fujitsu.com,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 5/9] usb: don't use PREPARE_DELAYED_WORK
Message-ID: <20140223042929.GA20474@mtj.dyndns.org>
References: <20140222153755.GG12830@htj.dyndns.org>
 <Pine.LNX.4.44L0.1402221752540.372-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1402221752540.372-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Alan.

On Sat, Feb 22, 2014 at 06:03:04PM -0500, Alan Stern wrote:
> >  then a single init work could be queued to
> > the system_unbound_wq which doesn't care about running times.
> 
> This sort of thing sounds like the best approach.  Tejun, do you want
> to rewrite the patch, getting rid of the hub_init_func3 and HUB_INIT3
> business entirely?  Or would you like me to do it?

I'll doing the minimal patch in this series and then following up with
the update is probably better.  I can put the patches in a separate
branch so that it can be easily pulled.

Thanks.

-- 
tejun
