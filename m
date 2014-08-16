Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaHPIKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 04:10:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36990 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaHPIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 04:10:13 -0400
Date: Sat, 16 Aug 2014 10:10:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3][update] PM / sleep: Introduce command line
 argument for sleep state enumeration
Message-ID: <20140816081007.GA21682@Nokia-N900>
References: <1817539.9KW2IGGbDV@vostro.rjw.lan>
 <2242480.eT2OxdNqLH@vostro.rjw.lan>
 <20140730105529.GB12448@amd.pavel.ucw.cz>
 <3319219.i7p5TE6seQ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3319219.i7p5TE6seQ@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-01 15:54:32, Rafael J. Wysocki wrote:
> On Wednesday, July 30, 2014 12:55:29 PM Pavel Machek wrote:
> > 
> > > For this reason I'm considering changing the defaul behavior going forward (so
> > > that "mem" is always present and means "the deepest sleep state available other
> > > than hibernation"), but I don't want to do that in one go.
> > 
> > Actually, I don't think that's good idea, at least on PC.
> > 
> > The way to wake up from S3 is power button. The way to wake up from
> > "echo freeze > state" is going to be different, right?
> 
> No, it isn't.  That's the point among other things.

There's difference, actually.

>From S3, power button event is consumed.

>From freeze, after resume, "what you want to do? power off,
suspend, hibernate" dialog appears.
