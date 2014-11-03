Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaKCSFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:05:40 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48040 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaKCSFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:05:35 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 3 Nov 2014 10:05:28 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
Message-ID: <20141103180528.GA9026@jtriplet-mobl1>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
 <20141103114656.3bf200df@lwn.net>
 <1415036860.17743.25.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415036860.17743.25.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 09:47:40AM -0800, Joe Perches wrote:
> On Mon, 2014-11-03 at 11:46 -0500, Jonathan Corbet wrote:
> > On Wed, 29 Oct 2014 11:15:17 -0700
> > Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > > Document several common practices and conventions regarding conditional
> > > compilation, most notably the preference for ifdefs in headers rather
> > > than .c files.
> > 
> > OK, I've picked this one up for my 3.19 docs pull.
> 
> I think that Al Viro's suggestion from awhile ago:
> 
> https://lkml.org/lkml/2013/3/20/388
> 
> could still be in CodingStyle somewhere or in
> another document like CodingStyleSuggestions.

I think that text needs some cleanup to better fit CodingStyle, but the
intent and recommendations definitely ought to go in.  A few of those
seem too far down the road of "don't stuff beans up your nose", and some
of them need shortening (just "don't put an else after an if condition
ending with break or return; remember to handle errors via break,
return, or continue, and outdent the subsequent code").

> Another thing that could go is the suggestion to
> use Lindent.
> 
> https://lkml.org/lkml/2013/2/11/390

Agreed completely.  We might consider coming up with settings for
clang-format, which seems like a far more capable replacement that
actually understands C.

- Josh Triplett
