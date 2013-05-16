Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3EPSIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:08:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:33645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab3EPSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:08:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,685,1363158000"; 
   d="scan'208";a="314770769"
Date: Thu, 16 May 2013 11:08:07 -0700
From: Jon Mason <jon.mason@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] NTB bug fixes for v3.10
Message-ID: <20130516180807.GC26226@jonmason-lab>
References: <20130511013000.GD14820@jonmason-lab>
 <CA+55aFxkSm34X_cwaQ9chue==SBpFNFfeOYB0dLg8WS1crz1iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxkSm34X_cwaQ9chue==SBpFNFfeOYB0dLg8WS1crz1iA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 03:22:52PM -0700, Linus Torvalds wrote:
> On Fri, May 10, 2013 at 6:30 PM, Jon Mason <jon.mason@intel.com> wrote:
> >
> >   https://github.com/jonmason/ntb.git for-linus
> 
> This has so much wrong that I don't know where to start.
> 
> Don't use the https transport unless you have to. Use the "git" one.
> 
> Also, that's an unsigned branch from an open hosting site. No. No. No.
> 
> If you use github or similar, you need to send me a signed tag, and
> your pgp key should in turn be signed by some key I recognize. Not
> this kind of "please pull this random branch from this random site"
> crap.
> 
>                 Linus

My apologies.  I have corrected the issues you described, and would appreciate you trying again with the updated information below.

Thanks,
Jon

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://github.com/jonmason/ntb.git tags/ntb-bugfixes-3.10

for you to fetch changes up to 8b19d450ad188d402a183ff4a4d40f31c3916fbf:

  NTB: Multiple NTB client fix (2013-05-15 10:58:22 -0700)

----------------------------------------------------------------
NTB bug fixes to address Smatch/Coverity errors, link toggling bugs,
and a few corner cases in the driver.

----------------------------------------------------------------
Dan Carpenter (2):
      ntb: off by one sanity checks
      NTB: fix pointer math issues

Jon Mason (8):
      NTB: variable dereferenced before check
      NTB: Handle 64bit BAR sizes
      NTB: Link toggle memory leak
      NTB: reset tx_index on link toggle
      NTB: Correctly handle receive buffers of the minimal size
      NTB: memcpy lockup workaround
      ntb_netdev: remove from list on exit
      NTB: Multiple NTB client fix

 drivers/net/ntb_netdev.c    |    2 ++
 drivers/ntb/ntb_hw.c        |   10 +++++-----
 drivers/ntb/ntb_transport.c |  175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------
 3 files changed, 121 insertions(+), 66 deletions(-)


