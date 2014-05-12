Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaELX2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:28:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64949 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751849AbaELX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:28:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, dirk.j.brandewie@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 4/5] intel_pstate: Remove C0 tracking
Date: Tue, 13 May 2014 01:45:19 +0200
Message-ID: <5584056.gWB1BqsgiU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5370DD27.5030701@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com> <5349714.j69a5Fx52S@vostro.rjw.lan> <5370DD27.5030701@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2014 07:39:35 AM Dirk Brandewie wrote:
> On 05/12/2014 05:16 AM, Rafael J. Wysocki wrote:
> > On Monday, May 12, 2014 05:27:25 AM Stratos Karafotis wrote:
> >> Hi,
> >>
> >
> > [cut]
> >
> >>
> >> With this patch, my CPU (Core i7-3770 @ 3.90GHz) seems to never use lowest
> >> frequencies. Even on an idle system I get always ~2GHz. Normally,
> >> on an idle system it used to be 1.6GHz.
> >> On very small loads (mp3 decoding) the CPU goes up to 2.7G GHz (it used to
> >> be 1.6GHz)
> >>
> >> Reverting, this patch on my local build, the problem is resolved.
> >
> > Dirk, seriously, I can't regard this as a fix that can go into -rc6.
> >
> 
> Ok I will resubmit after more testing
> 
> > Which of the other patch in the series are must-go for 3.15?  [1-2/5] I guess?
> > And do we need [2/5] it in -stable too?
> 
> 1/5  is for stable it fixes a random MCE on baytrail.
> 2/5  is for stable it should have went with the stop_cpu patch

Which -stable are these two for?  All of them?

> 5/5  can go too since it is just adding CPU IDs

Well, I'm a bit reluctant to push that for -rc6.  There were cases where new
IDs broke stuff that worked without them just fine.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
