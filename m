Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3GVBlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:41:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3GVBlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:41:51 -0400
Date: Sun, 21 Jul 2013 18:42:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [ 37/72] Input: bcm5974 - add support for the 2013 MacBook Air
Message-ID: <20130722014203.GA31697@kroah.com>
References: <20130719052559.852627424@linuxfoundation.org>
 <20130719052602.400119106@linuxfoundation.org>
 <20130719054040.GA20435@core.coreip.homeip.net>
 <20130719054445.GA14863@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719054445.GA14863@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 10:44:45PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 18, 2013 at 10:40:40PM -0700, Dmitry Torokhov wrote:
> > Greg,
> > 
> > On Thu, Jul 18, 2013 at 10:25:54PM -0700, Greg Kroah-Hartman wrote:
> > > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Dmitry Torokhov <rydberg@euromail.se>
> > 
> > Any chance you could change this to read "Henrik Rydberg"? My import
> > script messed up. And on hid part as well...
> 
> Ok, will do.

And I promptly forgot to do this, and I released 3.10.2 with it as-is,
sorry about that.

greg k-h
