Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3AZNTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:19:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:56429 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab3AZNTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:19:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: linux-next: Tree for Jan 25 (BROKEN suspend)
Date: Sat, 26 Jan 2013 14:25:47 +0100
Message-ID: <1378199.89Y5N0mHyy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 26, 2013 12:10:32 PM Sedat Dilek wrote:
> On Fri, Jan 25, 2013 at 6:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > Changes since 20130124:
> >
> > New trees: ipsec and ipsec-next
> >
> > The powerpc tree still had a build failure.
> >
> > The sound-asoc tree still had its build failure so I used the version from
> > next-20130122.
> >
> > The akpm tree lost its build failure and several patches that turned up
> > elsewhere.
> >
> > ----------------------------------------------------------------------------
> >
> 
> Unfortunately, on suspend or running the pm_test/freezer leads here to
> a frozen machine - hard reset.
> 
> I see 4-5 pages of call-traces but dunno how to log them in such a f-u-ed state.
> Any hints welcome!
> 
> As I saw catched with my left eye on one call-trace sth. with...
> 
>       kernel/watchdog.c (line #245, watchdog_overflow_callback)
> 
> ... I tried to revert the last two commits from Sascha (see -3 patch,
> but no success.
> 
> The same with reverting all cpu-freq changes since v3.8-rc4 (see -4
> patch) after seeing some suspicious lines on the screen.
> 
> Can someone confirm that suspend is BROKEN for him/her before doing
> eventually a bisect?

Can you please test the linux-next branch of the linux-pm.git tree alone?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
