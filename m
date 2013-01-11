Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3AKLnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:43:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab3AKLni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:43:38 -0500
Date: Fri, 11 Jan 2013 12:43:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130111114336.GE6570@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20130110093831.GA19503@liondog.tnic>
 <CADnq5_N9Dj5ZMoDaL9hp6R5wMkEf2yEL1C=66-PQ2+sLwwTm3g@mail.gmail.com>
 <20130110203248.GI23008@liondog.tnic>
 <CADnq5_MMk51H+Zy9GT9esfm_ndVqYzwU4t_6tYHu9zzSiqSr9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_MMk51H+Zy9GT9esfm_ndVqYzwU4t_6tYHu9zzSiqSr9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 03:47:01PM -0500, Alex Deucher wrote:
> >> Does disabling the new DMA ring for ttm bo moves avoid the issue?
> >
> > How do I do that?
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_asic.c
> b/drivers/gpu/drm/radeon/radeon_asic.c
> index 9056faf..b0cc46d 100644

[ … ]

Ok, I'm running -rc3 with this and will watch it for any changes in
behavior.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
