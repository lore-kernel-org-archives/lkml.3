Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab3BZPtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:49:09 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45244 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759651Ab3BZPtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:49:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>, Nishanth Menon <nm@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.9-rc1
Date: Tue, 26 Feb 2013 16:55:51 +0100
Message-ID: <2223198.XmyRLgb3Gv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com>
References: <1663657.ypAtqGpGAq@vostro.rjw.lan> <1781256.mPQbtiUPYR@vostro.rjw.lan> <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 25, 2013 09:31:45 PM Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 7:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > I wonder if this went unnoticed or there's anything wrong with it or it just
> > needs to wait for some more time?
> 
> Just going through things slowly. It's merged in my tree now.

Thanks!

> Oh, and a request: _please_ don't use unknown TLA's like OPP.

Sure, sorry about that.

> This has become a huge problem, to the point that we have a
> "Documentation/power/opp.txt" file THAT NEVER CLEARLY STATES WHAT THE
> F*CK OPP ACTUALLY MEANS! What nice "documentation".

It says that in "Introduction", but it would be clearer if the title of the
doc was something like "Operating Performance Points (OPP) Library".  Nishanth?

> Ok, I can look up things like this and find that it is "Operating
> Performance Points". At least in this context. But no, it's not some
> kind of generic standard, and no, it's not something people should be
> expected to know in general. Please stop doing "explanations" of
> things that use TLA's like this. And people shouldn't have to even
> wonder.

I agree.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
