Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab3BZXoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:44:25 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52786 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194Ab3BZXoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:44:23 -0500
Date: Tue, 26 Feb 2013 17:44:17 -0600
From: Nishanth Menon <nm@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: linux-pm <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / OPP: improve introductory documentation
Message-ID: <20130226234417.GA24893@kahuna>
References: <1361900231-10478-1-git-send-email-nm@ti.com>
 <512D3A9C.5040801@infradead.org>
 <20130226231038.GB24732@kahuna>
 <512D47AB.9030401@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <512D47AB.9030401@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:39-20130226, Randy Dunlap wrote:
> On 02/26/13 15:10, Nishanth Menon wrote:
> > On 14:43-20130226, Randy Dunlap wrote:
> >> On 02/26/13 09:37, Nishanth Menon wrote:
> > [..]
> >>>  
> >>>  1. Introduction
> >>>  ===============
> >>> +1.1 What is an Operating Performance Point (OPP)?
> >>> +
> >>>  Complex SoCs of today consists of a multiple sub-modules working in conjunction.
> >>>  In an operational system executing varied use cases, not all modules in the SoC
> >>>  need to function at their highest performing frequency all the time. To
> >>>  facilitate this, sub-modules in a SoC are grouped into domains, allowing some
> >>>  domains to run at lower voltage and frequency while other domains are loaded
> >>> -more. The set of discrete tuples consisting of frequency and voltage pairs that
> >>> +more.
> >>
> >> huh???
> > I split the definition line to it's own paragraph below. But, I think
> > you intend to say we could improve better the remaining paragraph.
> > Could you elaborate your thoughts?
> 
> "while other domains are loaded more."  Some people probably understand
> that OK; I dunno.  I would rather see it written out more verbosely, e.g.:
> 
> "while other domains run at voltage/frequency pairs that are higher."
You are right, being verbose here makes sense. I will pick up your wording
here in v2. Thanks for reviewing and helping improve.
> 
> but partly I was confused by the diff(1) lines.  my bad :(
no worries.

-- 
Regards,
Nishanth Menon
