Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3JBVL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:11:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44501 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3JBVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:11:54 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <87r4c3vavb.fsf@turtle.gmx.de>
References: <20130925001740.833541979@linuxfoundation.org>
	<20130925001741.446963782@linuxfoundation.org>
	<87r4c3vavb.fsf@turtle.gmx.de>
Date: Wed, 2 Oct 2013 23:11:53 +0200
Message-ID: <CAKMK7uHGVcEZt16aDgoUCfyRMtcw76geDtOvpd_qzMZ2+a7U_A@mail.gmail.com>
Subject: Re: [ 005/117] drm/i915: make user mode sync polarity setting explicit
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Imre Deak <imre.deak@intel.com>,
        "cancan,feng" <cancan.feng@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 7:30 PM, Sven Joachim <svenjoac@gmx.de> wrote:
> See also https://bugs.freedesktop.org/show_bug.cgi?id=65442#c16.

Oh dear, somehow I've thought the -fixes pull request I've sent with
the fix for this has a cc: stable, but that must have been lost
somewhere.

Greg, can you please queue up

commit 1062b81598bc00e2f6620e6f3788f8f8df2f01e7
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Sep 10 11:44:30 2013 +0200

    drm/i915/tv: clear adjusted_mode.flags

for stable kernels? Right now we seem to get about one dupe per day of
this report ;-)

/me wondered why they kept on coming up ...

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
