Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaAVM1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:27:37 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44211 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaAVM1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:27:32 -0500
Date: Wed, 22 Jan 2014 13:27:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: hpa@zytor.com, alan@linux.intel.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] MAINTAINERS: Restore "L:
 linux-kernel@vger.kernel.org" entries
Message-ID: <20140122122728.GA8882@gmail.com>
References: <tip-62f45f9a202c318fd5fb43cd40ef687b7dd2825f@git.kernel.org>
 <1390325069.2472.78.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390325069.2472.78.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> Also, SubmittingPatches had and still has:
> 
> 	6) Select your CC (e-mail carbon copy) list.
> 
> 	Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
> 
> Arguably, that same info should be added to the
> MAINTAINERS header instead of each section.

You have cut out my main argument from you reply and have ignored it:

>>    In hindsight removing all the "L: lkml" entries was probably not
>>    an overly good idea, not all mechanic duplication should be
>>    eliminated: in files read by humans it's useful to have 'at a
>>    glance' summary for all email addresses important to a subsystem's
>>    maintenance, in a single place, without too many imported rules
>>    and assumptions.

Which is not a very honest way to conduct discussions :-(

That section replies to most of your arguments.

> >   b5472cddbe2c MAINTAINERS: remove L: linux-kernel@vger.kernel.org from all but "THE REST"
> > 
> > So it turns out that it's all but intuitive, not all people
> > use scripts/get_maintainer.pl to extract maintainer contact info,
> > some people read the MAINTAINERS file and see the lack of 'L:' entries
> > of various lkml-only subsystems and are sending patches to the
> > maintainers only, without Cc:-ing lkml.  They arguably have a point.
> 
> shrug,  I think it would be better if people
> used get_maintainer more often.

People are people, they'll use well constructed human-readable sources 
of information like the MAINTAINERS file just fine.

> MAINTAINERS already says:

That's irrelevant really, reality tells us that good people are 
looking at the entries and are using them as-is. For such things 
technology should adapt to people, not the other way around.

> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -4655,6 +4657,7 @@ F:	net/irda/
> >  IRQ SUBSYSTEM
> >  M:	Thomas Gleixner <tglx@linutronix.de>
> >  S:	Maintained
> > +L:	linux-kernel@vger.kernel.org
> 
> If this is done, can you please standardize on
> placing the L: line immediately after the M: line
> and before the S: line as was done for all the
> other added lines.

Good point, fixed.

Thanks,

	Ingo
