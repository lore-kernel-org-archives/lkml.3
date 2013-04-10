Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3DJJ66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:58:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:57137 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab3DJJ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:58:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,445,1363158000"; 
   d="scan'208";a="284187213"
Date: Wed, 10 Apr 2013 11:58:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with the v4l-dvb tree
Message-ID: <20130410095852.GB4874@zurbaran>
References: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
 <20130410064253.GA4874@zurbaran>
 <20130410064828.6c946ad8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410064828.6c946ad8@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Apr 10, 2013 at 06:48:28AM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 10 Apr 2013 08:42:53 +0200
> Samuel Ortiz <sameo@linux.intel.com> escreveu:
> 
> > Hi Stephen,
> > 
> > On Wed, Apr 10, 2013 at 01:48:13PM +1000, Stephen Rothwell wrote:
> > > Hi Samuel,
> > > 
> > > Today's linux-next merge of the mfd tree got a conflict in
> > > drivers/mfd/Kconfig between commit 3f8ec5df11aa ("[media] mfd: Add header
> > > files and Kbuild plumbing for SI476x MFD core") from the v4l-dvb tree and
> > > commit ab85b120e692 ("mfd: Kconfig alphabetical re-ordering") from the
> > > mfd tree.
> > I'm surprised the v4l-dvb tree is carrying this patchset because I haven't
> > ACKed it. 
> 
> Sorry. Not sure why I understood that you gave your ack. Perhaps I miss-read
> one of the comments of that thread.
No worries, really. This has been a long thread...


> > I was planning to take the MFD bits of it and provide Mauro a branch
> > to pull from (Including the mfd/Kconfig change).
> > Mauro, could we please go that way instead ? This conflict does not look
> > pretty to me.
> 
> Sure. Do you have such branch already? As the patches are on my main
> tree[1], 
I don't have it yet. I asked Andrei to add a header to one of the MFD patches
because his patchset is currently not bisectable (The MFD patches include a
media/ header that is created later in the patchset). Once he has that done,
I'll create a branch for you to merge. I'll let you know when that's ready.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
