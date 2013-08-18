Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3HRTCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 15:02:16 -0400
Received: from oker.escape.de ([194.120.234.254]:33316 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3HRTCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:02:15 -0400
Date: Sun, 18 Aug 2013 20:48:49 +0200
From: Jochen Striepe <jochen@tolot.escape.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130818184848.GA2398@pompeji.miese-zwerge.org>
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818180232.GL29406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

On Sun, Aug 18, 2013 at 11:02:32AM -0700, Paul E. McKenney wrote:
> On Tue, Aug 13, 2013 at 12:32:03PM +0200, Jochen Striepe wrote:
> > just hit this one. Please tell me if you need any more information.
> 
> If you wait for a few minutes after the first stall warning message,
> do you get a second one with a much larger "t=" number?  That would help
> work out what part of the stack trace is responsible for the stall.

There was no more log lines other than backlight values changing for
about half an hour after that, and I switched off thereafter.
Unfortunately, I was not able to reproduce that behaviour since.

Best greetings,
Jochen.
