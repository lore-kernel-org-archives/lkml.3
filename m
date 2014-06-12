Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaFLTHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:07:23 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45245 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaFLTHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:07:21 -0400
Date: Thu, 12 Jun 2014 12:07:15 -0700
From: josh@joshtriplett.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: exceptions to what I maintain
Message-ID: <20140612190715.GA22610@cloud>
References: <5399DF99.2010701@infradead.org>
 <1402594501.12385.10.camel@joe-AO725>
 <5399E820.5080801@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5399E820.5080801@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:49:20AM -0700, Randy Dunlap wrote:
> On 06/12/14 10:35, Joe Perches wrote:
> > On Thu, 2014-06-12 at 10:12 -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Note that I don't maintain Documentation/ABI/,
> >> Documentation/devicetree/, or the language translation files.
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > 
> > Hey Randy.
> > 
> > Perhaps it's better to use exclusion "X:" values
> > so get_maintainer doesn't still include you.
> > 
> >> @@ -2885,7 +2885,7 @@ M:	Randy Dunlap <rdunlap@infradead.org>
> >>  L:	linux-doc@vger.kernel.org
> >>  T:	quilt http://www.infradead.org/~rdunlap/Doc/patches/
> >>  S:	Maintained
> >> -F:	Documentation/
> >> +F:	Documentation/ (but not: ABI, devicetree, translations)
> > 
> > Maybe:
> > 
> > X:	Documentation/ABI/
> > X:	Documentation/devicetree/
> > X:	Documentation/[a-z][a-z]_[A-Z][A-Z]/
> > 
> > The last line matches:
> > 
> > Documentation/ja_JP/
> > Documentation/ko_KR/
> > Documentation/zh_CN/
> > 
> > and it's easy to add any other directory you don't
> > want to cc'd on.
> 
> Thanks, I'll modify it to that syntax.
> That should satisfy Josh's comment also.

I'd forgotten about the existing X support.  Yes, that looks perfect,
thank you.

- Josh Triplett
