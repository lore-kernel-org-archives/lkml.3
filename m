Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3CVX72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:59:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34758 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3CVX71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:59:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add function to check that all MSR's are valid
Date: Sat, 23 Mar 2013 01:06:47 +0100
Message-ID: <5732099.5YOUCTPR4a@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130322150647.GA1632@redhat.com>
References: <1363796244-6658-1-git-send-email-dirk.brandewie@gmail.com> <1589305.6YMuneKuPN@vostro.rjw.lan> <20130322150647.GA1632@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 11:06:47 AM Dave Jones wrote:
> On Fri, Mar 22, 2013 at 01:40:49AM +0100, Rafael J. Wysocki wrote:
>  > On Thursday, March 21, 2013 01:08:03 AM Rafael J. Wysocki wrote:
>  > > On Wednesday, March 20, 2013 11:28:49 AM Dirk Brandewie wrote:
>  > > > On 03/20/2013 11:28 AM, Rafael J. Wysocki wrote:
>  > > > > On Wednesday, March 20, 2013 09:17:24 AM dirk.brandewie@gmail.com wrote:
>  > > > >> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>  > > > >>
>  > > > >> Some VMs seem to try to implement some MSRs but not all the registers
>  > > > >> the driver needs.  Check to make sure all the MSR that we need are
>  > > > >> available. If any of the required MSRs are not available refuse to
>  > > > >> load.
>  > > > >>
>  > > > >> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
>  > > > >
>  > > > > Is this needed for v3.9?  Any pointers to bug reports etc.?
>  > > > >
>  > > > 
>  > > > Sorry I saw right after I sent the mail that the bug report was missing
>  > > > 
>  > > >      https://bugzilla.redhat.com/show_bug.cgi?id=922923
>  > > >      Reported-by: Josh Stone <jistone@redhat.com>
>  > > > 
>  > > > Would you like me to spin the patch?
>  > > 
>  > > No, thanks, this information is sufficient.
>  > 
>  > Applied to linux-pm.git/bleeding-edge and will be moved to linux-next after
>  > build testing.
> 
> 'next' seems to be imply you're targetting this for 3.10 ?
> In case it wasn't clear, this is needed for 3.9.

I'm going to push this for 3.9 after it has spent a couple of days in
linux-next just in case.  So 3.9-rc5 is the target.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
