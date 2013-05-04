Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3EDI4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:56:42 -0400
Received: from r00tworld.com ([212.85.137.150]:43119 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab3EDI4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:56:40 -0400
From: "PaX Team" <pageexec@freemail.hu>
To: Daniel Vetter <daniel@ffwll.ch>, dl9pf@gmx.de,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Sat, 04 May 2013 10:55:50 +0200
MIME-Version: 1.0
Subject: Re: [Intel-gfx] [PATCH] [TRIVIAL] Fix declaration of intel_gmbus_{is_forced_bit/is_port_falid} in i915 driver.
Reply-to: pageexec@freemail.hu
CC: airlied@linux.ie, daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Message-ID: <5184CD16.8569.184037FF@pageexec.freemail.hu>
In-reply-to: <87k3ngtgme.fsf@intel.com>
References: <1367572662-18400-1-git-send-email-dl9pf@gmx.de>, <20130503092348.GL5763@phenom.ffwll.local>, <87k3ngtgme.fsf@intel.com>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Sat, 04 May 2013 10:55:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2013 at 15:03, Jani Nikula wrote:

> >> This fixes a compilation issue with clang. An initial version of this patch
> >> was developed by PaX Team <pageexec at freemail.hu>.
> >> This is respin of this patch.
> >> 
> >> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> >> CC: pageexec@freemail.hu
> >> CC: daniel.vetter@ffwll.ch
> >> CC: airlied@linux.ie
> >> CC: intel-gfx@lists.freedesktop.org
> >> CC: dri-devel@lists.freedesktop.org
> >> CC: linux-kernel@vger.kernel.org
> > Picked up for -fixes, thanks for the patch.
> 
> Please drop it.
> 
> The patch removes the inline keyword, creating dozens of copies of the
> functions, and consequently loads of warnings:

in my original patch they were both static inline, not sure where the
inline got lost...

