Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaF3OmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:42:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40725 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753669AbaF3OmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:42:19 -0400
Date: Mon, 30 Jun 2014 10:42:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
In-Reply-To: <2020781.AOFsAxmkyt@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1406301041170.1550-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Rafael J. Wysocki wrote:

> > > Do you know of any tools that actually look at these files?
> > 
> > I don't.  Of course, that doesn't mean much.
> 
> The only tool I'm aware of that may be looking at them is powertop, so
> if the change doesn't affect powertop adversely, it should be generally
> safe.
> 
> > > If there isn't any, then we can try to change it and see who screams :)
> > 
> > It'll be a learning experience...
> 
> Yes, it will. :-)

Then you have no other objections to the patch?

Alan Stern

