Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbaGAXAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 19:00:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56670 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757891AbaGAXAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 19:00:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Date: Wed, 02 Jul 2014 01:18:11 +0200
Message-ID: <3135210.ApPvOPL31q@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1406301041170.1550-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406301041170.1550-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2014 10:42:19 AM Alan Stern wrote:
> On Mon, 30 Jun 2014, Rafael J. Wysocki wrote:
> 
> > > > Do you know of any tools that actually look at these files?
> > > 
> > > I don't.  Of course, that doesn't mean much.
> > 
> > The only tool I'm aware of that may be looking at them is powertop, so
> > if the change doesn't affect powertop adversely, it should be generally
> > safe.
> > 
> > > > If there isn't any, then we can try to change it and see who screams :)
> > > 
> > > It'll be a learning experience...
> > 
> > Yes, it will. :-)
> 
> Then you have no other objections to the patch?

My concern still is that it will be confusing, because people won't read the
documentation carefully enough and will confuse "runtime PM never used" with
"hardware can't do PM".  I'm not sure how to make that more clear, though.

Also we have the no_callbacks flag and I wonder if/how it is related to the
new one.  Do we still need both?

In addition to that, I think that "hardware can't do PM" should apply to the
handling of system suspend resume too.

Rafael

