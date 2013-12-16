Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3LPTfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:35:11 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:4663 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3LPTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:35:09 -0500
Date: Tue, 17 Dec 2013 01:04:46 +0530
From: Hariprasad S <hariprasad@chelsio.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>, <felix@chelsio.com>
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20131216193446.GA10431@hariprasad-pc>
References: <20131215193220.GA7536@hariprasad-pc>
 <1387152449.2803.3.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387152449.2803.3.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.193.190.82]
X-OriginalArrivalTime: 16 Dec 2013 19:34:31.0040 (UTC) FILETIME=[D75A1800:01CEFA95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 00:07:29 +0000, Ben Hutchings wrote:
> On Mon, 2013-12-16 at 01:02 +0530, Hariprasad S wrote:
> > Hi,
> > 
> > Can you please pull from the following URL?
> >     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> > 
> > The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce824:
> >   Ben Hutchings (1):
> >           Merge branch 'wilink4' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware
> > 
> > are available in the git repository at:
> > 
> >   git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> 
> I'm no longer able to pull from this repository.  Depending on whether I
> use my cellular data or home DSL connection it fails with either:
> 
> $ git fetch git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> fatal: Could not read from remote repository.
> 
> Please make sure you have the correct access rights
> and the repository exists.
> 
> or:
> 
> $ git fetch git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> fatal: unable to connect to git.chelsio.net:
> git.chelsio.net[0: 67.207.112.37]: errno=Connection refused
> 
> Ben.
> 

Hi Ben,

There was some internal issue. Now that it is fixed, Can you please try pulling it now.

Thanks,
Hariprasad Shenai

> > Hariprasad Shenai (1):
> >     cxgb4: Updated T4 firmware, add T5 firmware
> > 
> >  WHENCE                  |    8 +++++---
> >  cxgb4/t4fw-1.6.2.0.bin  |  Bin 431616 -> 0 bytes
> >  cxgb4/t4fw-1.9.23.0.bin |  Bin 0 -> 486912 bytes
> >  cxgb4/t4fw.bin          |    2 +-
> >  cxgb4/t5fw-1.9.23.0.bin |  Bin 0 -> 481280 bytes
> >  cxgb4/t5fw.bin          |    1 +
> >  6 files changed, 7 insertions(+), 4 deletions(-)
> >  delete mode 100644 cxgb4/t4fw-1.6.2.0.bin
> >  create mode 100644 cxgb4/t4fw-1.9.23.0.bin
> >  create mode 100644 cxgb4/t5fw-1.9.23.0.bin
> >  create mode 120000 cxgb4/t5fw.bin
> > 
> > Thanks,
> > Hariprasad Shenai
> 
> -- 
> Ben Hutchings
> Lowery's Law:
>              If it jams, force it. If it breaks, it needed replacing anyway.


