Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3JFNzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 09:55:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35805 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3JFNzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 09:55:15 -0400
Date: Sun, 6 Oct 2013 15:55:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006135507.GA18082@pd.tnic>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
 <1381042912.2081.146.camel@joe-AO722>
 <20131006070557.GA1679@kroah.com>
 <20131006081033.GA18109@pd.tnic>
 <20131006134404.GB4706@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131006134404.GB4706@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 06:44:04AM -0700, Greg Kroah-Hartman wrote:
> On Sun, Oct 06, 2013 at 10:10:33AM +0200, Borislav Petkov wrote:
> > On Sun, Oct 06, 2013 at 12:05:57AM -0700, Greg Kroah-Hartman wrote:
> > > As an individual file is not the sum of the "program", I would argue
> > > that it is not needed, but some companies like to feel better by
> > > adding it. So I really don't mind either way, as it would involve
> > > arguing with lawyers about this type of thing, and I do enough of that
> > > already that I don't go out of my way to do it more...
> > 
> > What about a short sentence pointing at 'COPYING' instead?
> 
> Why?  What would that do?

Save us the short one or two lines "this file is ..."

> Listen, all we really need is a short one or two line "this file is
> released under the FOO license" in the file.  The SPDX project has the

All I'm suggesting is that it might be even simpler to add

"See COPYING in the kernel source repository for the license of this file."

or a similar text as COPYING contains the full text of the license.
Basically a pointer to it.

This has the added advantage to your short line that it points to the
exact license text and lawyers are happy.

<snip stuff we agree about anyway>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
