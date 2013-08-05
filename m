Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3HEJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:26:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42667 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3HEJ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:26:14 -0400
Date: Mon, 5 Aug 2013 11:26:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: i915 INFO: trying to register non-static key.
Message-ID: <20130805092612.GA23560@pd.tnic>
References: <20130731162252.GC4724@pd.tnic>
 <CAKMK7uFNpvSHxMXu6uzHbTwv4W=k_QZ2-g9X4hAK6wwniisrvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKMK7uFNpvSHxMXu6uzHbTwv4W=k_QZ2-g9X4hAK6wwniisrvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 01:06:35AM +0200, Daniel Vetter wrote:
> On Wed, Jul 31, 2013 at 6:22 PM, Borislav Petkov <bp@alien8.de> wrote:
> > Dudes,
> >
> > has anyone already reported this (happens on Linus of today +
> > tip/master):
> 
> I think this should be fixed with
> 
> commit e1b4d3036c07ff137955fb1c0197ab62534f46ec
> Author: Ben Widawsky <ben@bwidawsk.net>
> Date:   Tue Jul 30 16:27:57 2013 -0700
> 
>     drm/i915: fix missed hunk after GT access breakage
> 
> which is now in upstream git and -rc4.

Yes it is.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
