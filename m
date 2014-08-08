Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaHHThe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:37:34 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:33487 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaHHThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:37:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
References: <20140808143418.GA25720@phenom.ffwll.local>
	<CA+55aFxVsV58oi0E5H0dTRGH2r+WogkuzhncTJHy9F4d2sTTrA@mail.gmail.com>
Date: Fri, 8 Aug 2014 12:37:31 -0700
X-Google-Sender-Auth: CxoItzOLj_MEkFVCp8uhwvrwHdY
Message-ID: <CA+55aFxb1q9bwdM6_H=ctFHc+4rP4rBuzWMDNXVZwpwf0cN-Bw@mail.gmail.com>
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

On Fri, Aug 8, 2014 at 12:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Aug 8, 2014 at 7:34 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>
>>   git://anongit.freedesktop.org/drm-intel tags/drm-intel-fixes-2014-08-08
>
> Hmm. My laptop no longer resumes properly.

The problem seems to exist already with just the plain drm pull from
Dave. I thought I had tested that, but apparently not.

              Linus
