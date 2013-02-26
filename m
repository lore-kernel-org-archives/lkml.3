Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3BZXKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:10:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3BZXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:10:50 -0500
Date: Tue, 26 Feb 2013 17:10:38 -0600
From: Nishanth Menon <nm@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: linux-pm <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / OPP: improve introductory documentation
Message-ID: <20130226231038.GB24732@kahuna>
References: <1361900231-10478-1-git-send-email-nm@ti.com>
 <512D3A9C.5040801@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <512D3A9C.5040801@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:43-20130226, Randy Dunlap wrote:
> On 02/26/13 09:37, Nishanth Menon wrote:
[..]
> >  
> >  1. Introduction
> >  ===============
> > +1.1 What is an Operating Performance Point (OPP)?
> > +
> >  Complex SoCs of today consists of a multiple sub-modules working in conjunction.
> >  In an operational system executing varied use cases, not all modules in the SoC
> >  need to function at their highest performing frequency all the time. To
> >  facilitate this, sub-modules in a SoC are grouped into domains, allowing some
> >  domains to run at lower voltage and frequency while other domains are loaded
> > -more. The set of discrete tuples consisting of frequency and voltage pairs that
> > +more.
> 
> huh???
I split the definition line to it's own paragraph below. But, I think
you intend to say we could improve better the remaining paragraph.
Could you elaborate your thoughts?
> 
> > +
> > +The set of discrete tuples consisting of frequency and voltage pairs that
> >  the device will support per domain are called Operating Performance Points or
> >  OPPs.
> >  
> > +As an example:
> > +Let us consider an MPU device which supports the following:
> > +{300MHz at minimum voltage of 1V}, {800MHz at minimum voltage of 1.2V},
> > +{1GHz at minimum voltage of 1.3V}
> > +
> > +We can represent these as three OPPs as the following {Hz, uV} tuples:
> > +{300000000, 1000000}
> > +{600000000, 1200000}
>     800000000
> 
> > +{100000000, 1300000}
>     1000000000 ??
Thanks for catching it. will fix it in next rev.

-- 
Regards,
Nishanth Menon
