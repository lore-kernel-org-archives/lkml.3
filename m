Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3HBV5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:57:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53565 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752314Ab3HBV5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:57:24 -0400
Message-ID: <1375480643.2034.137.camel@joe-AO722>
Subject: Re: [PATCH] Tweak Documentation MAINTAINERS entry.
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 14:57:23 -0700
In-Reply-To: <CAMuHMdUqq1q1jeARpzHBVXTvPb2j8RvMxFBnQtTF4E85=D1opA@mail.gmail.com>
References: <1375459978.687125@landley.net>
	 <CAMuHMdUqq1q1jeARpzHBVXTvPb2j8RvMxFBnQtTF4E85=D1opA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 23:39 +0200, Geert Uytterhoeven wrote:
> On Fri, Aug 2, 2013 at 6:13 PM, Rob Landley <rob@landley.net> wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index d83f70f..6b752df 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2664,6 +2664,10 @@ L:       linux-doc@vger.kernel.org
> >  T:     TBD
> >  S:     Maintained
> >  F:     Documentation/
> > +X:     Documentation/zh_CN
> > +X:     Documentation/ko_KR
> > +X:     Documentation/ja_JP
> 
> Does "Documentation/??_??" work, to catch future translations?
> Or do we have to use "Documentation/[a-z][a-z]_[A-Z][A-Z]"?

? works.

The script uses:
scripts/get_maintainer.pl:                      $line =~ s/([^\\])\.([^\*])/$1\?$2/g;

These could be converted to a single

X:	Documentation/??_??/


