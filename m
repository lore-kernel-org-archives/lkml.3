Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBGOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:51:57 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:38355 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaBGOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:51:56 -0500
Date: Fri, 7 Feb 2014 15:51:49 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Borislav Petkov <bp@alien8.de>
Cc: Imre Deak <imre.deak@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: intel_sdvo_init: trying to register non-static key
Message-ID: <20140207145149.GZ17001@phenom.ffwll.local>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20140207093205.GA24395@pd.tnic>
 <87d2iz18vi.fsf@intel.com>
 <1391771542.5669.6.camel@intelbox>
 <20140207112809.GG24395@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207112809.GG24395@pd.tnic>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 12:28:09PM +0100, Borislav Petkov wrote:
> On Fri, Feb 07, 2014 at 01:12:22PM +0200, Imre Deak wrote:
> > On Fri, 2014-02-07 at 13:04 +0200, Jani Nikula wrote:
> > > Imre, is this the same i2c_del_adapter issue you're looking at? Any
> > > patches to try yet?
> > 
> > It looks like the same issue yes. The following patch fixed it for me:
> > 
> > http://patchwork.freedesktop.org/patch/18698/
> > 
> > I'm working on an improved version of this, but the main thing - to
> > remove the connector's sysfs entries before actually destroying the
> > encoder and connector objects - will remain the same as in the above
> > patch.
> 
> You could shoot the final version my way so that I give it a run too.

The final version will only change the code layout a bit, but not the
logic. So a tested-by from you for v1 would be helpful anyway, to make
really sure you've reported the same issue. If that's not the case then we
need to dig deeper, so better not to waste a few days waiting for v2.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
