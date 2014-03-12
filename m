Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaCLXAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 19:00:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46127 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaCLXAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 19:00:11 -0400
Date: Thu, 13 Mar 2014 00:00:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140312230007.GA1817@amd.pavel.ucw.cz>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
 <1511662.Ly2fOjCGKz@vostro.rjw.lan>
 <1392765307.3488.1.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392765307.3488.1.camel@x230.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-02-18 23:15:08, Matthew Garrett wrote:
> On Wed, 2014-02-19 at 00:26 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, February 18, 2014 11:28:29 AM Matthew Garrett wrote:
> > > 
> > > The ACPI IPMI driver implements IPMI operation region support for the ACPI
> > > core. Systems that declare ACPI operation regions may reference them at any
> > > time, including during kernel initialisation. These accesses will fail
> > > unless the ACPI IPMI driver is present, and undesirable system behaviour
> > > may result. Set the default to Y in order to encourage distributions and
> > > users to configure kernels to avoid awkward surprises.
> > 
> > Do you have any examples of problems caused by that or is this just theoretical
> > at the moment?
> 
> For example, if you load the ACPI power meter driver before you've
> installed the ACPI IPMI driver you'll typically get failures (most
> vendors implement it via IPMI).

Would the right solution be to implement dependency between power
meter and IMPI?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
