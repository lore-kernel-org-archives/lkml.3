Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaDVRdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:33:55 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54882 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbaDVRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:33:53 -0400
Date: Tue, 22 Apr 2014 19:33:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [Intel-gfx] [Bug 3.15-rc2] [bisected] intel framebuffer broken
Message-ID: <20140422173348.GX10722@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Knut Petersen <Knut_Petersen@t-online.de>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <53554B59.8080107@t-online.de>
 <87tx9lh95w.fsf@intel.com>
 <535675CC.1020402@t-online.de>
 <871twpbdth.fsf@intel.com>
 <1398183760.21147.85.camel@intelbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398183760.21147.85.camel@intelbox>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 07:22:40PM +0300, Imre Deak wrote:
> On Tue, 2014-04-22 at 18:10 +0300, Jani Nikula wrote:
> > Knut, thanks for a quick bisect.
> > 
> > Imre, please have a look at the sdvo WARN related to sysfs links in the
> > dmesg.
> 
> It's probably the same WARN fixed by:
> http://patchwork.freedesktop.org/patch/24126/

Knut, can you please check that this patch gets rid of the WARN?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
