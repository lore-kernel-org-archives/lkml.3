Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbaAFTg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:36:56 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:41860 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbaAFTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:36:55 -0500
Date: Mon, 6 Jan 2014 13:36:52 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 0/1] Makefile: Use CPPFLAGS from the environment
Message-ID: <20140106193652.GB1556@thinkpad-t410>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <1389030985-26657-1-git-send-email-seth.forshee@canonical.com>
 <20140106140753.55f3f3c7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106140753.55f3f3c7@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 02:07:53PM -0500, Steven Rostedt wrote:
> On Mon,  6 Jan 2014 11:56:24 -0600
> Seth Forshee <seth.forshee@canonical.com> wrote:
> 
> > Hi Steve,
> > 
> > Here's another patch for trace-cmd that I'm using in Debian. Please
> > consider it for your tree.
> > 
> > It also looks like you haven't applied the patches I sent a few months
> > back [1][2]. I'm guessing you just forgot about them, but please let me
> > know if there's something I need to fix. I also pushed out all of these
> > patches if you'd prefer to do a pull:
> 
> I actually applied everything, and a lot more updates that I never
> pushed.
> 
> Anyway, thanks! I applied this too and pushed it up.

Thanks!

There is something odd about the updates you pushed though. You've now
got a version 2.2.1 on your trace-cmd-stable-v2.2 branch, which used to
be tagged trace-cmd-v2.2.1, and another 2.2.1 on master which now has
that tag. I'm guessing that's not what you intended to do?

Seth

