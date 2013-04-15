Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122Ab3DOTut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:50:49 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:61459 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935091Ab3DOTup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:50:45 -0400
Date: Mon, 15 Apr 2013 12:50:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Bryan ODonoghue <bryan.odonoghue.lkml@nexus-software.ie>
Subject: Re: [ 27/27] tty: dont deadlock while flushing workqueue
Message-ID: <20130415195038.GB26557@kroah.com>
References: <20130415024231.351969241@linuxfoundation.org>
 <20130415024233.376898638@linuxfoundation.org>
 <1366054656.4124.14.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366054656.4124.14.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 03:37:36PM -0400, Peter Hurley wrote:
> [ -cc Alan Cox ]
> 
> On Sun, 2013-04-14 at 19:43 -0700, Greg Kroah-Hartman wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > 
> > commit 852e4a8152b427c3f318bb0e1b5e938d64dcdc32 upstream.
> 
> Greg,
> 
> So many other serious error conditions are possible here, it seems
> pointless to add this to 3.8-stable.

The submitter said it fixed a real problem that they were having in the
3.8 kernel, so I think it is relevant for that reason alone.

thanks,

greg k-h
