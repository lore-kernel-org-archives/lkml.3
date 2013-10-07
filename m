Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3JGB1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:27:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57421 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3JGB1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:27:06 -0400
Date: Mon, 7 Oct 2013 02:27:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
Message-ID: <20131007012704.GA22371@srcf.ucam.org>
References: <20131006205928.GA20296@srcf.ucam.org>
 <CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
 <20131006233106.GA21562@srcf.ucam.org>
 <CAMP44s1-vCgOkE_h1ZEmCA2WiQyLTOvnis2MOjdu8kdDB39kFg@mail.gmail.com>
 <20131006235702.GA21738@srcf.ucam.org>
 <CAMP44s3+GdeN6ZFxi6dKZ_1kyTgmgjTf4ET=pJnkSwoirZQMjw@mail.gmail.com>
 <20131007003247.GA21999@srcf.ucam.org>
 <CAMP44s1knbxW5C_tRSqopRLd+b2fXfuH=E3_L4EdOAUG4RMVhg@mail.gmail.com>
 <20131007005355.GA22211@srcf.ucam.org>
 <CAMP44s0jCvzrBDuiGe=q=tJyQGSGt47aAeJJyPgEtrQB_qXq1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0jCvzrBDuiGe=q=tJyQGSGt47aAeJJyPgEtrQB_qXq1Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 08:01:34PM -0500, Felipe Contreras wrote:
> On Sun, Oct 6, 2013 at 7:53 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > No, it demonstrably doesn't. The comments that do exist refer to only a
> > subset of the entries underneath them.
> 
> That's not true.
> 
> /*
> * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
> * Linux ignores it, except for the machines enumerated below.
> */

You appear to have missed the continuation of that comment directly 
underneath which lists a subset of the devices covered by the quirks.

> > Having a per-entry comment is significantly clearer.
> 
> That is your opinion, it's not a demonstrable fact.

Say one of the machines turns out to need the quirk for two different 
reasons. How do we document that? Look, how about you add the comments 
and I'll do a patch that adds documentation to the existing entries? I'm 
not asking you to make up for other people's past mistakes, I'm asking 
you not to perpetuate them.

> And just to be clear, you are saying that in the following code, you
> have no idea which statements correspond to which sections. Am I
> correct?

No, that's not what I'm saying. But I'm now going to a bar and drink 
instead of having to justify why *clearly documenting this code* is a 
worthwhile thing to do.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
