Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3JGAyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:54:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57268 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab3JGAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:53:58 -0400
Date: Mon, 7 Oct 2013 01:53:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
Message-ID: <20131007005355.GA22211@srcf.ucam.org>
References: <20131006204518.GA20077@srcf.ucam.org>
 <CAMP44s0GkVyw+PRYKqq7=MXFFtgUO9xCq6jTsoQV-rSRmC23yg@mail.gmail.com>
 <20131006205928.GA20296@srcf.ucam.org>
 <CAMP44s33CByGsRz7vsNAoOLnbEMY+fz73NzHJq07BzSuCEGJUg@mail.gmail.com>
 <20131006233106.GA21562@srcf.ucam.org>
 <CAMP44s1-vCgOkE_h1ZEmCA2WiQyLTOvnis2MOjdu8kdDB39kFg@mail.gmail.com>
 <20131006235702.GA21738@srcf.ucam.org>
 <CAMP44s3+GdeN6ZFxi6dKZ_1kyTgmgjTf4ET=pJnkSwoirZQMjw@mail.gmail.com>
 <20131007003247.GA21999@srcf.ucam.org>
 <CAMP44s1knbxW5C_tRSqopRLd+b2fXfuH=E3_L4EdOAUG4RMVhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s1knbxW5C_tRSqopRLd+b2fXfuH=E3_L4EdOAUG4RMVhg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 07:50:18PM -0500, Felipe Contreras wrote:
> On Sun, Oct 6, 2013 at 7:32 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > I don't get the final
> > say in whether or not this patch gets merged, but there's a decent
> > chance that I'm going to be the one who has to remove the entries again
> > once the backlight mess is fixed up. My life would be significantly
> > easier if the entries are unambiguously identified in such a way that I
> > can remove them without having to dig through git history to figure out
> > where each came from.
> 
> And a *single* comment on top of this group entries achieves that just
> fine. You haven't provided a single argument as to why that wouldn't
> be the case.

No, it demonstrably doesn't. The comments that do exist refer to only a 
subset of the entries underneath them. Having a per-entry comment is 
significantly clearer. Given that I have to delete things from this file 
and you don't, I have absolutely no idea why you refuse to believe me on 
this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
