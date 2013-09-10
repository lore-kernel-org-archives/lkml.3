Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3IJKeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:34:11 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49566 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3IJKeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:34:09 -0400
Date: Tue, 10 Sep 2013 12:34:21 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/sdvo: Fully translate sync flags in
 the dtd->mode conversion
Message-ID: <20130910103421.GK27291@phenom.ffwll.local>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <522A5008.6060005@t-online.de>
 <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130910082452.GI11428@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130910082452.GI11428@intel.com>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 11:24:52AM +0300, Ville Syrjälä wrote:
> On Tue, Sep 10, 2013 at 10:02:48AM +0200, Daniel Vetter wrote:
> > Instead of just a flag bit for each of the positive/negative sync
> > modes drm actually uses a separate flag for each ... This upsets the
> > modeset checker since the adjusted mode filled out at modeset time
> > doesn't match the one reconstructed at check time (since the
> > ->get_config callback already gets this right).
> > 
> > Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
> > Cc: Knut Petersen <Knut_Petersen@t-online.de>
> > References: http://www.gossamer-threads.com/lists/linux/kernel/1778688?do=post_view_threaded
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Picked up for -fixes, thanks for the review.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
