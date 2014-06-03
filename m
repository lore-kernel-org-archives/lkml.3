Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaFCGeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:34:20 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53076 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaFCGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:34:19 -0400
Message-ID: <1401777254.6214.107.camel@marge.simpson.net>
Subject: Re: nouveau + rt = boom
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 03 Jun 2014 08:34:14 +0200
In-Reply-To: <1401715317.5757.10.camel@marge.simpson.net>
References: <1401714764.5757.3.camel@marge.simpson.net>
	 <1401715040.5757.7.camel@marge.simpson.net>
	 <538C79E6.4070306@linutronix.de>
	 <1401715317.5757.10.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 15:21 +0200, Mike Galbraith wrote: 
> On Mon, 2014-06-02 at 15:19 +0200, Sebastian Andrzej Siewior wrote: 
> > On 06/02/2014 03:17 PM, Mike Galbraith wrote:
> > > TODO++: Rummage around in this nouveau -rt explosion.
> > 
> > https://lkml.org/lkml/2014/3/7/163
> 
> Aha, thanks.

I hit instability in a SLE nopreempt kernel yesterday with the thing
too, one of the events being an fs BUG() that just happened to occur
immediately after my display went gaga.  Playing with nouveau in box I
need for daily bread could be a bad idea.  (chicken) TODO--

-Mike

