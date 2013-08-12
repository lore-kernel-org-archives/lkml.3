Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3HLEMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 00:12:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3HLEMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 00:12:34 -0400
Date: Sun, 11 Aug 2013 21:13:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>, stable@vger.kernel.org,
        Alexander Z Lam <azl@google.com>
Subject: Re: [for-next-3.11][PATCH 4/4] tracing: Fix reset of time stamps
 during trace_clock changes
Message-ID: <20130812041357.GA14626@kroah.com>
References: <20130803124926.157378122@goodmis.org>
 <20130803125117.748903207@goodmis.org>
 <1375978326.6848.66.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375978326.6848.66.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:12:06PM -0400, Steven Rostedt wrote:
> Greg,
> 
> I'm testing the backports, and I found that this patch depends on commit
> 10246fa35d4ffdfe472185d4cbf9c2dfd9a9f023 "tracing: Use flag
> buffer_disabled for irqsoff tracer"
> 
> Please add that to 3.10 before applying this fix.

Oops, I sent out the "FAILED" email before seeing this, sorry about
that.  I've applied this patch, and now the original one applies as
well, thanks.

greg k-h
