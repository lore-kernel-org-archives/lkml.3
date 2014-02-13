Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaBMAp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:45:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56001 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751095AbaBMAp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:45:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: dirk.brandewie@gmail.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 0/5] intel_pstate updates for v3.14-rcX
Date: Thu, 13 Feb 2014 02:00:09 +0100
Message-ID: <1625364.33ktXkOf95@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412818.o51aAvTvMU@vostro.rjw.lan>
References: <1392228067-14817-1-git-send-email-dirk.j.brandewie@intel.com> <1412818.o51aAvTvMU@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 13, 2014 01:47:43 AM Rafael J. Wysocki wrote:
> On Wednesday, February 12, 2014 10:01:02 AM dirk.brandewie@gmail.com wrote:
> > From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> > 
> > Based on v3.14-rc2
> > 
> > Patch 1 removes energy reporting the patch from Maurizio Lambardi 
> >  intel_pstate: fix race condition in intel_pstate_init() can be dropped.
> > 
> 
> OK, I'll replace that patch with your [1/5].

On a second thought, we'll need a fix for stable for that and quite frankly
your [1/5] doesn't really fit there.  So I'm going to push the Maurizio's
patch anyway and plaese rebase the whole series on top of it.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
