Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3G2XBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:01:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60268 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755005Ab3G2XBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:01:23 -0400
Message-ID: <1375138880.2075.82.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: enforce sane perl version
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@sr71.net>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 16:01:20 -0700
In-Reply-To: <20130729155210.cc90c5790ad83d63bd30e508@linux-foundation.org>
References: <20130729200606.2651EE1E@viggo.jf.intel.com>
	 <1375128613.2075.56.camel@joe-AO722>
	 <20130729155210.cc90c5790ad83d63bd30e508@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 15:52 -0700, Andrew Morton wrote:
> On Mon, 29 Jul 2013 13:10:13 -0700 Joe Perches <joe@perches.com> wrote:
> > On Mon, 2013-07-29 at 13:06 -0700, Dave Hansen wrote:
> > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > > I got a bug report from a couple of users who said
> > > checkpatch.pl was broken for them.  It was erroring out on
> > > fairly random lines most commonly with messages like:
> > > 
> > > 	Nested quantifiers in regex; marked by <--HERE in m/(\((?:[^\(\)]++ <-- HERE |(?-1))*\))/ at ./checkpatch.pl line 340.
> > > 
> > > The bug reporter was running a version of perl 5.8 which was
> > > end-of-lifed in 2008
[]
> > Other than Andrew Morton's (continuing?) use of perl 5.8
> > I'm fine with this.
> > 
> > Andrew?  Time to update your perl version?
> 
> I run an FC6 test box just to irritate you guys.

;)

yabut do you (have to) use checkpatch on that
creakingly old test box?

Maybe I can find a box with slackware 2.0 for you.
It had perl 5.0.0.


