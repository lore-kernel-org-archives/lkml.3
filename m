Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab3CVPG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab3CVPGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:06:55 -0400
Date: Fri, 22 Mar 2013 11:06:47 -0400
From: Dave Jones <davej@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add function to check that all
 MSR's are valid
Message-ID: <20130322150647.GA1632@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Dirk Brandewie <dirk.brandewie@gmail.com>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	Dirk Brandewie <dirk.j.brandewie@intel.com>
References: <1363796244-6658-1-git-send-email-dirk.brandewie@gmail.com>
 <5149FFE1.7030706@gmail.com>
 <13387259.b2vHhipG0R@vostro.rjw.lan>
 <1589305.6YMuneKuPN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589305.6YMuneKuPN@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 01:40:49AM +0100, Rafael J. Wysocki wrote:
 > On Thursday, March 21, 2013 01:08:03 AM Rafael J. Wysocki wrote:
 > > On Wednesday, March 20, 2013 11:28:49 AM Dirk Brandewie wrote:
 > > > On 03/20/2013 11:28 AM, Rafael J. Wysocki wrote:
 > > > > On Wednesday, March 20, 2013 09:17:24 AM dirk.brandewie@gmail.com wrote:
 > > > >> From: Dirk Brandewie <dirk.brandewie@gmail.com>
 > > > >>
 > > > >> Some VMs seem to try to implement some MSRs but not all the registers
 > > > >> the driver needs.  Check to make sure all the MSR that we need are
 > > > >> available. If any of the required MSRs are not available refuse to
 > > > >> load.
 > > > >>
 > > > >> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
 > > > >
 > > > > Is this needed for v3.9?  Any pointers to bug reports etc.?
 > > > >
 > > > 
 > > > Sorry I saw right after I sent the mail that the bug report was missing
 > > > 
 > > >      https://bugzilla.redhat.com/show_bug.cgi?id=922923
 > > >      Reported-by: Josh Stone <jistone@redhat.com>
 > > > 
 > > > Would you like me to spin the patch?
 > > 
 > > No, thanks, this information is sufficient.
 > 
 > Applied to linux-pm.git/bleeding-edge and will be moved to linux-next after
 > build testing.

'next' seems to be imply you're targetting this for 3.10 ?
In case it wasn't clear, this is needed for 3.9.

	Dave

