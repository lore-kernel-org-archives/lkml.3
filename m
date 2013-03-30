Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab3C3SFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 14:05:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34353 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab3C3SFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 14:05:16 -0400
Date: Sat, 30 Mar 2013 19:05:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Message-ID: <20130330180513.GD28947@amd.pavel.ucw.cz>
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com>
 <20130120092537.GB16066@arwen.pp.htv.fi>
 <201301201117.32096@pali>
 <20130121080506.GA8777@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130121080506.GA8777@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-01-21 10:05:06, Felipe Balbi wrote:
> Hi,
> 
> On Sun, Jan 20, 2013 at 11:17:31AM +0100, Pali Rohár wrote:
> > On Sunday 20 January 2013 10:25:37 Felipe Balbi wrote:
> > > On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Rohár wrote:
> > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > 
> > > NAK for two reasons:
> > > 
> > > a) the original Nokia kernel used a separate g_file_storage
> > > gadget to use Mass Storage mode, use that
> > > 
> > > b) there is no commit log
> > 
> > Reason why add mass storage mode to g_nokia is to avoid switching 
> > between g_{file,mass}_storage and g_nokia and to have one gadget 
> > driver for Nokia N900. It is better to have usb network and mass 
> > storage mode in one driver (and not to unload & load another).
> > 
> > I tested this patch with 3.8-rc3 kernel on Nokia N900 and usb 
> > network with mass storage mode working without problems.
> 
> Doesn't matter, in this case this is something which nokia wrote to
> carry on their Maemo/MeeGo devices so unless someone from Nokia says
> this is how they want to use nokia.c from now on, I can't simply risk
> breaking all other users for your own convenience.

Nokia is unlikely to continue linux development, sorry.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
