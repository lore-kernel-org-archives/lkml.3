Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaCPIxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 04:53:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47713 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaCPIxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 04:53:51 -0400
Date: Sun, 16 Mar 2014 09:53:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Corey Minyard <minyard@acm.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140316085341.GA18516@amd.pavel.ucw.cz>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
 <1511662.Ly2fOjCGKz@vostro.rjw.lan>
 <1392765307.3488.1.camel@x230.lan>
 <20140312230007.GA1817@amd.pavel.ucw.cz>
 <1394666568.25122.1.camel@x230>
 <20140313072204.GA7181@amd.pavel.ucw.cz>
 <1394695475.25122.4.camel@x230>
 <20140313083832.GA8902@amd.pavel.ucw.cz>
 <5321B2B2.9060109@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321B2B2.9060109@acm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Defaults are not right solution; system should still work if I select
> > non-default settings. Which you claim is not a case, but you don't see
> > why you should fix it.
> 
> If something is implemented using IPMI, then IPMI has to be there to
> use it.  Matthew's statement was:
> 
> For example, if you load the ACPI power meter driver before you've
> installed the ACPI IPMI driver you'll typically get failures (most
> vendors implement it via IPMI).

Yes, and this failure is not fixed with different default.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
