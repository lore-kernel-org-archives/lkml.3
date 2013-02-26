Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab3BZQhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:37:19 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45838 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab3BZQhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:37:17 -0500
Date: Tue, 26 Feb 2013 08:37:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nishanth Menon <nm@ti.com>, Aaron Lu <aaron.lu@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.9-rc1
Message-ID: <20130226163712.GA30433@htj.dyndns.org>
References: <1663657.ypAtqGpGAq@vostro.rjw.lan>
 <1781256.mPQbtiUPYR@vostro.rjw.lan>
 <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com>
 <2223198.XmyRLgb3Gv@vostro.rjw.lan>
 <20130226161049.GA9303@kahuna>
 <CA+55aFy24fp+9zXiDmAgvsz6YvWQh2L0BAJ2hAhF7cNSdyMd8w@mail.gmail.com>
 <CA+55aFyu5woJsH2y3y=w4UFneOG8hKz_cLXgZQbJzn5asn8=hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyu5woJsH2y3y=w4UFneOG8hKz_cLXgZQbJzn5asn8=hQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:28:56AM -0800, Linus Torvalds wrote:
> > Aaron, Tejun, Jeff, can I ask you to also not use specialized TLA's
> > without explaining them? Especially in help text and "documentation",
> > it's very unhelpful to have TLA's that aren't common.
> >
> > We don't have to explain *all* TLA's, since there's a lot that really
> > are rather widespread. But there's a big difference between something
> > like CPU or TLB that have been in generic literature for decades, wrt
> > OPP and ODD that are specialized terms used inside a very particular
> > group and haven't been around for very long either.

Aye aye, captain.

One interesting bit, for me (and possibly Aaron too), ODD is much more
closer to an everyday term.  For some reason, at least in Korea, ODD
is a popular term.  For exmple, the likes of newegg would use it along
with CPU, SSD or VGA to label product categories, so that probably is
why ODD never registered as something which needed explanation, and
that we all are pretty familiar with ATA jargons.  Anyways, yeah, no
ODDs without expansion nearby.

Thanks.

-- 
tejun
