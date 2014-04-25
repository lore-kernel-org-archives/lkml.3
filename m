Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaDYCVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 22:21:32 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34232 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYCVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 22:21:30 -0400
Date: Thu, 24 Apr 2014 22:21:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-04-24
Message-ID: <20140425020421.GD3410@tuxdriver.com>
References: <20140424145329.GD7832@joana>
 <20140425014446.GC3410@tuxdriver.com>
 <C9BCBE06-78C4-41C6-9B70-BFB2C6AFDF7A@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C9BCBE06-78C4-41C6-9B70-BFB2C6AFDF7A@holtmann.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 06:51:13PM -0700, Marcel Holtmann wrote:
> Hi John,
> 
> > This tag has a lot of stuff in it not in the wireless tree.
> > Please only send me pull requests that only include patches related
> > to Bluetooth.
> > 
> >> Some fixes for 3.15. There is a revert for the intel driver, a new device id,
> >> and two important SSP fixes from Johan.
> >> Also we've noticed that your wireless.git tree is not up to date, so this pull
> >> was rebased on top of net.git. If you pull from this you'll will be pulling
> >> net/master from yesterday as well.
> 
> as Gustavo explained, this is against net.git since wireless.git has not yet been rebased.
> 
> Regards
> 
> Marcel

wireless.git is where it is going to be.  It is based from a few dozen
commits before -rc1, which was what Dave had as the base of his tree
when I started merging post -rc1 fixes into wireless.git.

I'm sorry if this is inconvenient, but among other things this keeps
net.git and linux.git stuff from getting into wireless-testing.git
prematurely.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
