Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaCERWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:22:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbaCERWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:22:34 -0500
Date: Wed, 5 Mar 2014 18:22:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel@ffwll.ch>
cc: Borislav Petkov <bp@alien8.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
In-Reply-To: <20140305171558.GM17001@phenom.ffwll.local>
Message-ID: <alpine.LNX.2.00.1403051821090.3690@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz> <alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz> <20140304134509.GA5427@pd.tnic> <20140305170640.GE28317@pd.tnic> <20140305171558.GM17001@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Daniel Vetter wrote:

> > > Maybe I should say that I'm booting the box with
> > > 
> > > [ 0.000000] Kernel command line: 
> > > BOOT_IMAGE=/boot/vmlinuz-3.14.0-rc5+ root=/dev/sdb2 ro 
> > > root=/dev/sdb2 ignore_loglevel log_buf_len=10M resume=/dev/sdb1 
> > > i915.i915_enable_rc6=4 i915.i915_enable_fbc=1 i915.lvds_downclock=1 
> > > i915.powersave=1
> > 
> > From looking at
> > 
> > http://lkml.kernel.org/r/1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch
> > 
> > it looks like I should stop using the rc6/fbc settings?
> > 
> > :-)
> 
> Indeed. If going back to defaults fixes your issues, then it's not a real
> bug. There are reasons the defaults are as-is ...

Let's not have the issues mixed.

The one originally reported in this thread

  *ERROR* render ring initialization failed ctl 0001f001 head 00003004 tail 00000000 start 00003000

and subsequent resume busted is there even with the default i915 driver 
settings.

Thanks,

-- 
Jiri Kosina
SUSE Labs
