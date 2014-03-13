Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaCMIih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:38:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54573 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaCMIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:38:34 -0400
Date: Thu, 13 Mar 2014 09:38:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140313083832.GA8902@amd.pavel.ucw.cz>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
 <1511662.Ly2fOjCGKz@vostro.rjw.lan>
 <1392765307.3488.1.camel@x230.lan>
 <20140312230007.GA1817@amd.pavel.ucw.cz>
 <1394666568.25122.1.camel@x230>
 <20140313072204.GA7181@amd.pavel.ucw.cz>
 <1394695475.25122.4.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394695475.25122.4.camel@x230>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-03-13 07:24:36, Matthew Garrett wrote:
> On Thu, 2014-03-13 at 08:22 +0100, Pavel Machek wrote:
> > On Wed 2014-03-12 23:22:49, Matthew Garrett wrote:
> > > No. The power meter driver knows nothing about IPMI. It makes no IPMI
> > > calls. There's no requirement that a vendor implement it via IPMI.
> > 
> > Yet you claim that IMPI is needed for that, and that's why you made
> > IMPI default.
> 
> I claim that the ACPI spec defines the behaviour of IPMI operation
> regions, and so we should default IPMI to Y in order to (by default)
> implement the ACPI spec.
> 
> > So ... do we need dmi-based blacklist?
> 
> I don't see why.

Your reasoning for default y was that "power meter depends on
this". Then, claim that "power meter does not officially depend on it"
so it would be wrong to have a dependency.

Defaults are not right solution; system should still work if I select
non-default settings. Which you claim is not a case, but you don't see
why you should fix it.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
