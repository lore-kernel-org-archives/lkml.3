Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaJHCkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:40:18 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:49687 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJHCkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:40:16 -0400
Date: Tue, 7 Oct 2014 21:40:11 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] ring-buffer: Fix infinite spin in reading buffer
Message-ID: <20141007214011.158a7b2e@as>
In-Reply-To: <20141005234943.GB23078@kroah.com>
References: <20141003162043.6817a486@gandalf.local.home>
	<20141005234943.GB23078@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 16:49:43 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Fri, Oct 03, 2014 at 04:20:43PM -0400, Steven Rostedt wrote:

...

> >     Fixes: 651e22f2701b "ring-buffer: Always reset iterator to reader page"
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Next time, please also add a Cc: stable...  here so that my tools pick
> it up automatically.
> 

Can you add "Fixes:" to the list of keywords your tools pick up, and
determine if the patch is needed in -stable by looking at the commit ID
that's being fixed? Some authors might not remember if the thing being
fixed has made it into an older release via -stable.
