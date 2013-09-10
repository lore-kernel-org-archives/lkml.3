Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab3IJJ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:28:26 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48734 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3IJJ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:28:24 -0400
Date: Tue, 10 Sep 2013 11:28:37 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, ville.syrjala@linux.intel.com
Subject: Re: [PATCH] drm/i915/sdvo: Fully translate sync flags in the
 dtd->mode conversion
Message-ID: <20130910092837.GJ27291@phenom.ffwll.local>
Mail-Followup-To: Knut Petersen <Knut_Petersen@t-online.de>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, ville.syrjala@linux.intel.com
References: <522A5008.6060005@t-online.de>
 <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
 <522EDB3D.7040504@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522EDB3D.7040504@t-online.de>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:41:33AM +0200, Knut Petersen wrote:
> On 10.09.2013 10:02, Daniel Vetter wrote:
> >Instead of just a flag bit for each of the positive/negative sync
> >modes drm actually uses a separate flag for each ... This upsets the
> >modeset checker since the adjusted mode filled out at modeset time
> >doesn't match the one reconstructed at check time (since the
> >->get_config callback already gets this right).
> >
> >Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> >Cc: Knut Petersen <Knut_Petersen@t-online.de>
> >References: http://www.gossamer-threads.com/lists/linux/kernel/1778688?do=post_view_threaded
> 
> Thanks for the patch, but it does _not_ cure the problem, see attached boot dmesg.

Oh, it fixed the first mismatch afaict, but I've missed that the tv load
detect also causes fun ;-) Working on a 2nd patch ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
