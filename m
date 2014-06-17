Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032AbaFQUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964886AbaFQUvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:51:52 -0400
Date: Tue, 17 Jun 2014 16:51:25 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: corrected sub-chapter number
Message-ID: <20140617205125.GC19353@madcap2.tricolour.ca>
References: <1537cb738c6d4998106c5b91626b69f742d2b47d.1402946960.git.rgb@redhat.com>
 <53A07A87.3010908@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A07A87.3010908@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/17, Randy Dunlap wrote:
> On 06/16/14 12:48, Richard Guy Briggs wrote:
> > The index is correct, but there are two sections tagged 3.7.  Fix.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> 
> This seems to already be fixed by commit 49d063cb353265c3af701bab215ac438ca7df36d
> on April 7, 2014.

Good, thanks, and it is already upstream.  Disregard mine.  :)

I've got another potential patch coming that will add 3.9 to document
existing /proc/<pid>/ns/* and additions to that filespec.

> > ---
> >  Documentation/filesystems/proc.txt |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> > index f00bee1..68e3a76 100644
> > --- a/Documentation/filesystems/proc.txt
> > +++ b/Documentation/filesystems/proc.txt
> > @@ -1648,7 +1648,7 @@ pids, so one need to either stop or freeze processes being inspected
> >  if precise results are needed.
> >  
> >  
> > -3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
> > +3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
> >  ---------------------------------------------------------------
> >  This file provides information associated with an opened file. The regular
> >  files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
> 
> ~Randy

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
