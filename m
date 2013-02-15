Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935763Ab3BOOrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:47:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38288 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab3BOOrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:47:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Date: Fri, 15 Feb 2013 15:53:34 +0100
Message-ID: <2185970.g9YrD945My@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130216005014.c8ce70e041f655d4c195c9fb@canb.auug.org.au>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au> <20130215132624.GB11777@phenom.dumpdata.com> <20130216005014.c8ce70e041f655d4c195c9fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 16, 2013 12:50:14 AM Stephen Rothwell wrote:
> Hi Konrad,
> 
> On Fri, 15 Feb 2013 08:26:24 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >
> > Thank you. I keep on forgetting - but would it be OK for me to take this
> > patch in my tree? Or should I not since this is a new functionality that
> > Rafael is going to introduce in v3.9?
> 
> It is an API change in the pm tree that is not yet in Linus' tree.
> 
> > And if so, perhaps I should tack it on in my tree, once Rafael does a git
> > pull to Linus? Or just point Linus to this git commit?
> 
> You should point Linus at this patch if the pm tree is merged first, or
> Rafael should do the same if the reverse happens.

Alternatively, Konrad can pull the acpi-scan branch containing the changes
in question from my tree into his tree and rebase the new material on top
of that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
