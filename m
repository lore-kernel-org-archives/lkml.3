Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBSATy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:19:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64554 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752234AbaBSATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:19:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: dirk.j.brandewie@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] intel_pstate updates for v3.14-rcX
Date: Wed, 19 Feb 2014 01:34:35 +0100
Message-ID: <4187014.8zm183CESa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5303F28C.4060906@intel.com>
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com> <2705558.gK5sRhMz43@vostro.rjw.lan> <5303F28C.4060906@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 03:53:48 PM Dirk Brandewie wrote:
> On 02/18/2014 02:27 PM, Rafael J. Wysocki wrote:
> > On Tuesday, February 18, 2014 12:29:54 PM Dirk Brandewie wrote:
> >> Hi Rafael,
> >
> > Hi,
> >
> >> On 02/12/2014 10:01 AM, dirk.brandewie@gmail.com wrote:
> >>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> >>>
> >>> Based on v3.14-rc2
> >>>
> >>> Patch 1 removes energy reporting the patch from Maurizio Lambardi
> >>>    intel_pstate: fix race condition in intel_pstate_init() can be dropped.
> >>>
> >>
> >> Any reason why patches 2-5 did not make rc3 other than timing?
> >>
> >> Patches 2/3 can easily wait for v3.15.x
> >>
> >> Patches 4/5 fix bugs that are in the wild.
> >
> > I asked you about them, but you didn't reply:
> >
> > http://marc.info/?l=linux-pm&m=139225158531023&w=4
> >
> > Again, do patches [4-5/5] depend on [2-3/5]?
> >
> > If not, I can queue them up for -rc4.
> 
> All the patches are independent of one another.
> 
> Patch 2 is straight cleanup no functional change but reduces the memory
> footprint slightly.
> 
> Patch 3 is a bug that will only be seen when the PID is reset at init time
> or when a change is made to PID params via debugfs.  The problem will only
> exist for one sample time since it is setting last_err in the PID.
> 
> Patch 4-5 are bugs found during Baytrail-T testing

Are there any pointers to bug reports that may be included in the changelogs
of these?

Rafael

