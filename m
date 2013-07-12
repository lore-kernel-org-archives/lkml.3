Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965476Ab3GLVTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:19:16 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47944 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3GLVTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:19:13 -0400
Date: Fri, 12 Jul 2013 16:19:09 -0500
From: "Justin M. Forbes" <jmforbes@linuxtx.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712211909.GA3797@linuxtx.org>
References: <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712181103.GA6689@roeck-us.net>
 <20130712193557.GB342@thunk.org>
 <1373658551.17876.117.camel@gandalf.local.home>
 <20130712201939.GB15261@redhat.com>
 <1373660900.17876.124.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373660900.17876.124.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 04:28:20PM -0400, Steven Rostedt wrote:
> 
> I would suspect that machines that allow unprivileged users would be
> running distro kernels, and not the latest release from Linus, and thus
> even a bug that "can allow an unprivileged user to crash the kernel" may
> still be able to sit around for a month before being submitted.
> 
But distros *do* ship the latest release from Linus. Fedora is often
shipping .1 releases, and sometimes .0.  This seems to be getting more
difficult though as more and more fixes have been left for stable to fix
and the Linus release contains a number of known regressions.
We know about those regressions not just from following lists, but because
we have users running rawhide kernels which are snapshots of Linus' tree
almost daily.  They see the regressions and complain.  So yeah, there are
machines out there running Linus' latest tree.

Justin
