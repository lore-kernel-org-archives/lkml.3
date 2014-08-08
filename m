Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaHHTTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:19:37 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:64554 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaHHTTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:19:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140808143418.GA25720@phenom.ffwll.local>
References: <20140808143418.GA25720@phenom.ffwll.local>
Date: Fri, 8 Aug 2014 12:19:35 -0700
X-Google-Sender-Auth: X740kPXr4i0B-zoGw0_tfhzXGgY
Message-ID: <CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
Subject: Re: [PULL] drm-intel-fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 7:34 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
>   git://anongit.freedesktop.org/drm-intel tags/drm-intel-fixes-2014-08-08

Hmm. My laptop no longer resumes properly.

Or rather, I suspect it resumes, but the screen is black.

I will bisect, and I *will* revert if I find the offending commit. I
need that laptop for travel next week.

            Linus
