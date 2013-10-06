Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3JFNop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 09:44:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3JFNom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 09:44:42 -0400
Date: Sun, 6 Oct 2013 06:44:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006134404.GB4706@kroah.com>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
 <1381042912.2081.146.camel@joe-AO722>
 <20131006070557.GA1679@kroah.com>
 <20131006081033.GA18109@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006081033.GA18109@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 10:10:33AM +0200, Borislav Petkov wrote:
> On Sun, Oct 06, 2013 at 12:05:57AM -0700, Greg Kroah-Hartman wrote:
> > As an individual file is not the sum of the "program", I would argue
> > that it is not needed, but some companies like to feel better by
> > adding it. So I really don't mind either way, as it would involve
> > arguing with lawyers about this type of thing, and I do enough of that
> > already that I don't go out of my way to do it more...
> 
> What about a short sentence pointing at 'COPYING' instead?

Why?  What would that do?

Listen, all we really need is a short one or two line "this file is
released under the FOO license" in the file.  The SPDX project has the
shortend tags that can be used for it, and someone should be marking up
the whole kernel with them soon, which will be good.

Otherwise, it's up to the contributor, what they want to have in the
file.  But wrong addresses isn't ok, I'm sure we can all agree about
that.

thanks,

greg k-h
