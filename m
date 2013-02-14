Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab3BNOUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:20:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48417 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab3BNOUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:20:03 -0500
Date: Thu, 14 Feb 2013 15:19:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: rostedt@goodmis.org, Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Including drm-intel tree to linux-next
Message-ID: <20130214141953.GA5746@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, rostedt@goodmis.org,
	Dave Airlie <airlied@gmail.com>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 03:12:02PM +0100, Daniel Vetter wrote:
> Hi Steven,
> 
> Since about a year ago we've switched drm/i915 to buffer around 2
> weeks worth of patches so that we can do decent QA before breaking
> everyone's tree when things land in Dave's drm-next. But that also
> means we'll miss out a bit in the integration testing -next provides,
> which did hurt a bit in recent efforts. Hence can you please include
> 
> git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued
> 
> into linux-next? Probably best to merge it after drm-next. Note that
> drm-intel-next are the QA'ed chunks I send off to Dave. Also, any
> mailing lists I'm supposed to follow? And if possible please cc
> intel-gfx@lists.freedesktop.org besides dri-devel/lkml when conflicts
> with that tree pop up (you won't get moderation spam any more, we've
> fixed that up).

I think you want to send this here to Stephen Rothwell. CCed.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
