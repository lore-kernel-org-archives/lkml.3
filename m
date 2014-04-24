Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaDXH0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:26:24 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:56462 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaDXH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:26:22 -0400
Message-ID: <1398324378.6486.5.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Thu, 24 Apr 2014 09:26:18 +0200
In-Reply-To: <5358B960.7040106@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
	 <1398312391.5415.16.camel@marge.simpson.net>
	 <5358B960.7040106@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 09:12 +0200, Sebastian Andrzej Siewior wrote: 
> On 04/24/2014 06:06 AM, Mike Galbraith wrote:
> > Turning lockdep on, it says it's busted.
> 
> http://www.spinics.net/lists/linux-rt-users/msg11179.html

I was heading toward the same conclusion while regression testing.
Guess I can stop that.

-Mike

