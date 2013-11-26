Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab3KZSGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:06:50 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33345 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3KZSGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:06:46 -0500
Date: Tue, 26 Nov 2013 19:06:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>, freemangordon@abv.bg
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126180643.GA32057@amd.pavel.ucw.cz>
References: <201311191151.17153@pali>
 <201311261810.22885@pali>
 <20131126171748.GA26429@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131126171748.GA26429@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-11-26 18:17:49, Sebastian Reichel wrote:
> On Tue, Nov 26, 2013 at 06:10:22PM +0100, Pali Rohár wrote:
> > On Tuesday 19 November 2013 11:51:12 Pali Rohár wrote:
> > > For a long time (since 3.5 or 3.8? - I do not remember) obex
> > > subdriver in g_nokia usb gadget module causing kernel panic
> > > after module is loaded on Nokia N900. I do not know where is
> > > problem and due to immediatelly kernel crash when loading
> > > driver I was not able to see any dmesg output. Now I was able
> > > to store something into mtd log and here is crash backtrace:
> > > [...]
> > 
> > Hi! can you look at this problem?
> 
> So it worked at some time?
> Have you tried to git bisect the problem?

You are a cruel person :-). N900 historically boots about half of the
time, trying to do git bisect there is a nice weekend project... for
about next century or so.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
