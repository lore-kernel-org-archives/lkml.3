Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbaCUPz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:55:59 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59732 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbaCUPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:55:58 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <alpine.LNX.2.00.1403211621510.3690@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz>
	<alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz>
	<alpine.LNX.2.00.1403101525220.3690@pobox.suse.cz>
	<CAKMK7uG1PG=h8uiofNXt_-GOGgL354skaQeqA5OxK4VbYk2Vkg@mail.gmail.com>
	<alpine.LNX.2.00.1403101540140.3690@pobox.suse.cz>
	<alpine.LNX.2.00.1403211621510.3690@pobox.suse.cz>
Date: Fri, 21 Mar 2014 16:55:57 +0100
Message-ID: <CAKMK7uHE+cpdf42oL80H8ui=j0QiQsY5+v_paz6E+YeC-Zzr_Q@mail.gmail.com>
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 4:23 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> So I am still seeing this with current Linus' tree rather regularly (but
> it's not deterministic enough for a reliable bisect).
>
> Unfortunately I haven't received any patches to test; what do you propose?
> Would reporting this on bugs.freedesktop.org instead of ranting here
> change anything?

Yeah, filing a bug on fdo to keep track of this should help. Please
add a [gm45 regression] tag to the summary so that it shows up in our
queries at the right spot ;-)

One thing to test would be to give -nightly (or drm-intel-testing as
of today) a shot. We've merged a few patches recently to slightly
improve the ring init sequence in the generic code, they might
actually help here. Sorry for not correlating them with your patch
when I've merged them, only just realized this now.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
