Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3AVMTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:19:52 -0500
Received: from mxout-07.mxes.net ([216.86.168.182]:18506 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3AVMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:19:49 -0500
Date: Tue, 22 Jan 2013 07:19:47 -0500
From: Brad Tilley <brad@16s.us>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: PROBLEM: 3.8.0-rc4 keyboard failure at boot
Message-ID: <20130122121947.GB27072@16s.us>
References: <20130121213604.GA31225@16s.us>
 <20130122001346.GD16638@core.coreip.homeip.net>
 <alpine.LNX.2.00.1301221122380.20374@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301221122380.20374@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:23:27AM +0100, Jiri Kosina wrote:
> On Mon, 21 Jan 2013, Dmitry Torokhov wrote:
> 
> > > Here is info from a computer where the keyboard works occasionally at
> > > boot (about 50% of the time). Users reboot until the keyboard works.
> > > 
> > 
> > Hmm, this is a USB keyboard so let's CC Jiri in addition to
> > linux-input...
> 
> Thanks for the report.
> 
> First question before we start any further analysis -- what is the latest 
> known-good version of the kernel, where this problem didn't happen on this 
> particular computer?

Kernels 3.7.3 and 3.7.4 do not have this issue. It began with the 3.8 rcs.

Brad

