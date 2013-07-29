Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3G2WwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:52:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3G2WwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:52:12 -0400
Date: Mon, 29 Jul 2013 15:52:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dave Hansen <dave@sr71.net>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: enforce sane perl version
Message-Id: <20130729155210.cc90c5790ad83d63bd30e508@linux-foundation.org>
In-Reply-To: <1375128613.2075.56.camel@joe-AO722>
References: <20130729200606.2651EE1E@viggo.jf.intel.com>
	<1375128613.2075.56.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 13:10:13 -0700 Joe Perches <joe@perches.com> wrote:

> On Mon, 2013-07-29 at 13:06 -0700, Dave Hansen wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > I got a bug report from a couple of users who said
> > checkpatch.pl was broken for them.  It was erroring out on
> > fairly random lines most commonly with messages like:
> > 
> > 	Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./checkpatch.pl line 340.
> > 
> > The bug reporter was running a version of perl 5.8 which was
> > end-of-lifed in 2008: http://www.cpan.org/src/.  Versions of perl
> > this old are at _best_ quite untested.  At worst, they are crusty
> > and known to be completely broken.
> > 
> > If folks have a system _that_ old, then we should have mercy on
> > them and give them a half-decent error message rather than fail
> > with nutty error messages.
> > 
> > This patch enforces that checkpatch.pl is run with perl 5.10,
> > which was end-of-lifed in 2009.  The new --ignore-perl-version
> > command-line switch will let folks override this if they want.
> > 
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Other than Andrew Morton's (continuing?) use of perl 5.8
> I'm fine with this.
> 
> Andrew?  Time to update your perl version?

I run an FC6 test box just to irritate you guys.


