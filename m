Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaBLWlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:41:10 -0500
Received: from imap.thunk.org ([74.207.234.97]:57249 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbaBLWlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:41:08 -0500
Date: Wed, 12 Feb 2014 17:40:58 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: postmaster@vger.kernel.org
Cc: Kees Cook <kees@outflux.net>, Dave Jones <davej@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Subject: Re: flaw in "nf_tables: add reject module for NFPROTO_INET"
Message-ID: <20140212224058.GA7237@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, postmaster@vger.kernel.org,
	Kees Cook <kees@outflux.net>, Dave Jones <davej@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
References: <52fb24097b42_6b5073486c727c3@209.249.196.67.mail>
 <20140212204307.GK23300@outflux.net>
 <20140212205037.GA6563@redhat.com>
 <20140212205453.GL23300@outflux.net>
 <20140212210347.GB6563@redhat.com>
 <20140212210554.GM23300@outflux.net>
 <20140212213151.GB12617@thunk.org>
 <20140212214112.GN23300@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212214112.GN23300@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:41:12PM -0800, Kees Cook wrote:
> On Wed, Feb 12, 2014 at 09:31:51PM +0000, tytso@mit.edu wrote:
> > I'm paying attention to Linux kernel coverity reports (as well as
> > working on my goal to drive the number of e2fsprogs coverity reports
> > to zero :-), so feel free to CC me on any reports.
> 
> Okay, 3 people sounds like "we need a mailing list". :) Who's best to
> ask for that?

+postmaster@vger.kernel.org

Hi Dave, Matti,

Would it be possible to set up a new mailing list on vger.kernel.org,
linux-coverity@vger.kernel.org?

Many thanks!!

					- Ted
