Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaGKFxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 01:53:14 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48633 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaGKFxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 01:53:13 -0400
Date: Fri, 11 Jul 2014 06:52:59 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, "David S. Miller" <davem@davemloft.net>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [BISECTED][REGRESSION] Loading Hyper-V network drivers is racy
 in 3.14+ on Hyper-V 2012 R2
Message-ID: <20140711055259.GA10317@sucs.org>
References: <20140706201800.GA10587@sucs.org>
 <941b0055b1a94c66b3a608ae67764d11@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140707181341.GA2646@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707181341.GA2646@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 07:13:41PM +0100, Sitsofe Wheeler wrote:
> On Mon, Jul 07, 2014 at 04:54:20PM +0000, Haiyang Zhang wrote:
> > 
> > > -----Original Message-----
> > > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > > Sent: Sunday, July 6, 2014 4:18 PM
> > > To: Haiyang Zhang
> > > Cc: KY Srinivasan; David S. Miller; devel@linuxdriverproject.org; linux-
> > > kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: [BISECTED][REGRESSION] Loading Hyper-V network drivers is racy in
> > > 3.14+ on Hyper-V 2012 R2
> > > 
> > > With the 3.14 kernel Hyper-V no longer reliably enables its
> > > networking devices in time on cloud images leading to network
> > > devices permanently remaining offline.
> > > 
> <snip>
> > > the system will usually stop rebooting before 20 passes but the most
> > > extreme cases were always less than 100. With a pre
> > > b679ef73edc251f6d200a7dd2396e9fef9e36fc3 kernel it did over 390
> > > passes before I manually stopped it.
> > > 
> > > Originally filed on https://bugzilla.redhat.com/show_bug.cgi?id=1095387
> > > and then on https://bugzilla.kernel.org/show_bug.cgi?id=78771 but without
> > > reply...
> > > 
> > > Might also be related to
> > > http://thread.gmane.org/gmane.linux.kernel/1711873/focus=1733398
> > > (Regression in hyperv network driver in 3.14).
> > 
> > What's the memory size assigned to the Linux guest? And, have you seen
> > any related messages in the dmesg log after this issue?
> 
> (Feel free to trim my emails when replying - it makes it easier to see
> your reply :-)
> 
> I've had as little as 256 MBytes and as much as 4 GBytes (non-dynamic)
> and still seen the issue.
> 
> See https://bugzilla.kernel.org/attachment.cgi?id=142201 for a recent
> dmesg (an older dmesg snippet can be seen on the Red Hat bugzilla).

Oops that should have been
https://bugzilla.kernel.org/attachment.cgi?id=142351 (either way it's
information linked off
https://bugzilla.kernel.org/show_bug.cgi?id=78771 ).

-- 
Sitsofe | http://sucs.org/~sits/
