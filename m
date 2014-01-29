Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaA2NBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:01:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaA2NBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:01:31 -0500
Date: Wed, 29 Jan 2014 05:02:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Oleg Drokin <green@linuxhacker.ru>, Joe Perches <joe@perches.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] lustre: add myself to list of people to CC on lustre
 patches
Message-ID: <20140129130236.GC1727@kroah.com>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
 <1390538708-4120-6-git-send-email-green@linuxhacker.ru>
 <1390542276.32356.22.camel@joe-AO722>
 <8ADC515E-0EB5-4891-A6C9-CEAEA5E50E34@linuxhacker.ru>
 <CAMuHMdWXvyTpoafetr63-80GWppZGC3y72otuf89d3LJoKwXOQ@mail.gmail.com>
 <AB57D4F6-7E01-43E6-A421-F73BE52AB74C@linuxhacker.ru>
 <CAMuHMdWi4KPYa6GmkSgjxpL-mMxJB5FHG2FuoQ7UEWNpEqt-9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWi4KPYa6GmkSgjxpL-mMxJB5FHG2FuoQ7UEWNpEqt-9g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 08:28:33PM +0100, Geert Uytterhoeven wrote:
> On Sat, Jan 25, 2014 at 4:23 AM, Oleg Drokin <green@linuxhacker.ru> wrote:
> > On Jan 24, 2014, at 3:55 AM, Geert Uytterhoeven wrote:
> >> On Fri, Jan 24, 2014 at 6:51 AM, Oleg Drokin <green@linuxhacker.ru> wrote:
> >>>> +STAGING - LUSTRE
> >>>> +M:   Andreas Dilger <andreas.dilger@intel.com>
> >>>> +M:   Oleg Drokin <oleg.drokin@intel.com>
> >>>> +M:   Peng Tao <tao.peng@emc.com>.
> >>>> +L:   hpdd-discuss <hpdd-discuss@lists.01.org>
> >>>> +S:   Odd Fixes
> >>>
> >>> Actually we are at least Maintained here, if not outright Supported.
> >>
> >> Good to hear that!
> >> So can we assume that https://lkml.org/lkml/2013/9/9/725 will be fixed
> >> shortly,
> >
> > We are working on it.
> 
> Thanks!
> 
> >> and http://kisskb.ellerman.id.au/kisskb/buildresult/10508264/
> >> will turn green again?
> >
> > I certainly hope so.
> > BTW, do you also provide interface where I can drop in my patch and your builder verify it for me by any chance,
> 
> It's called linux-next, but Lustre is part of staging, which is already
> included. No idea how lustre gets updated in thes staging tree, though.

Like any other patch that gets sent to drivers/staging, through my
staging.git tree.
