Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaEIQO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:14:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:32556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaEIQO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:14:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1019,1389772800"; 
   d="scan'208";a="536548626"
Date: Fri, 9 May 2014 17:14:38 +0100
From: Damien Lespiau <damien.lespiau@intel.com>
To: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
Message-ID: <20140509161438.GH31479@strange.amr.corp.intel.com>
References: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
 <CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
 <CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 06:11:37PM +0200, Jörg Otte wrote:
> > Jörg, can you please boot with drm.debug=0xe, reproduce the issue and
> > then attach the complete dmesg? Please make sure that the dmesg
> > contains the boot-up stuff too.
> >
> > Thanks, Daniel
> Here it is. I should mention it only happens at boot-up.

[    0.374095] [drm] Wrong MCH_SSKPD value: 0x20100406
[    0.374096] [drm] This can cause pipe underruns and display issues.
[    0.374097] [drm] Please upgrade your BIOS to fix this.

-- 
Damien
