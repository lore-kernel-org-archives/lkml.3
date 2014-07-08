Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaGHNlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:41:06 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50990 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaGHNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:41:02 -0400
Date: Tue, 8 Jul 2014 15:41:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Masaru Nomura <massa.nomura@gmail.com>, airlied@linux.ie,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/3] gpu: drm: Remove unnecessary parameter from
 drm_ht_remove_item()
Message-ID: <20140708134111.GF17271@phenom.ffwll.local>
Mail-Followup-To: Thomas Hellstrom <thellstrom@vmware.com>,
	Masaru Nomura <massa.nomura@gmail.com>, airlied@linux.ie,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com>
 <1403646734-2838-3-git-send-email-massa.nomura@gmail.com>
 <20140708112442.GA17271@phenom.ffwll.local>
 <53BBD8BC.7040602@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BBD8BC.7040602@vmware.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 01:40:44PM +0200, Thomas Hellstrom wrote:
> On 07/08/2014 01:24 PM, Daniel Vetter wrote:
> > On Tue, Jun 24, 2014 at 10:52:13PM +0100, Masaru Nomura wrote:
> >> removed drm_open_hash from drm_ht_remove_item() as the parameter is
> >> not used within the function.
> >>
> >> Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
> >> ---
> >> Please review this patch carefully. The reason the parameter is passed
> >> might be some historical one or clarity of which drm_open_hash
> >> we remove an item from.
> > Reasons for this are probably lost. On the patch:
> >
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
> 
> >
> > Aside: Imo we could/should just move all the users to directly employ the
> > linux hashtab instead of partially reinventing the wheel here in drm.
> > -Daniel
> >
> 
> Actually, in this case, the wheel was invented in drm before it was made
> generic :).
> It's possible to utilize part of "hashtable.h" but I don't think the
> code size gain
> will be major...

Yeah, lots of work and little gain ;-) There needs to be a terribly boring
and rainy day to get around to that ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
