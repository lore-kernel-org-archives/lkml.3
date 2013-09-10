Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab3IJXSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:18:43 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40964 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3IJXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:18:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130910205027.GI23294@tallgrass.jf.intel.com>
References: <alpine.DEB.2.00.1309051139240.25450@skynet.skynet.ie>
 <CA+55aFwyKmVWkrV3=XiuruZzeTicpfW-JrwjWzpq9eP2yGPeJA@mail.gmail.com>
 <CA+qSnqh1X6_xHD4GX1P=acEUg9+0=3dVSZHm-NYXvCvupFB8_g@mail.gmail.com>
 <CA+55aFzRCNteHoSBRL9cVAHtZwA419G+fPBAaofYextsHpDLYw@mail.gmail.com> <20130910205027.GI23294@tallgrass.jf.intel.com>
From: Sean V Kelley <sean.v.kelley@intel.com>
Date: Tue, 10 Sep 2013 16:18:21 -0700
Message-ID: <CA+qSnqiBHTPSe2k=oKyfiYORB3t=JektQ4JbFbOpLkA9BTi3_Q@mail.gmail.com>
Subject: Re: [git pull] drm tree for 3.12-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 1:50 PM, Sean V Kelley <sean.v.kelley@intel.com> wrote:
> On Tue, Sep 10, 2013 at 08:49:58AM -0700, Linus Torvalds writes :
>> [ Dave - your linux.ie email generates bounces for me, trying redhat instead ]
>>
>> On Mon, Sep 9, 2013 at 11:25 PM, Sean V Kelley <sean.v.kelley@intel.com> wrote:
>> >>
>> >> I'm also a bit bummed that hw acceleration of video doesn't seem to
>> >> work on Haswell, meaning that full-screen is now a jerky mess. I fear
>> >> that that is user-space libraries/X.org, but I thought I'd mention it
>> >> in the hope of getting a "oh, it's working for us, you'll get a fix
>> >> for it soon".
>> >
>> > Can you give a little more detail about video not working?  Video
>> > accel should work fine with the current versions of libva/intel-driver
>> > available in Fedora 19 - assuming that's what you're using.
>>
>> It is indeed F19.
>>
>> Easy test: go to youtube, and watch things that are in 1080p HD. They
>> play fine in a window (using about 70% CPU), but full-screened to
>> 2560x1440 they play at about one or two frames per second.
>
> Yep.  I see the same.  Chrome is brain dead and appears to simply
> rely on Flash + FFmpeg software codecs.  At least with Firefox you
> know it will suck and not be hw accelerated. Unless that has changed...
>
....
>
> Ironically, it is relatively trivial for me to do a chromium browser
> build form source myself and enable libva/intel-driver HW accel, h.264.  And say
> screw you to flash et al, and leave that out.  And that will
> work fine for html5 video on youtube with fallback to SW accel for VP8
> based content.  Why it is a chore for Google is not clear to me...


Google actually blacklists hardware video acceleration for Linux x86
in Chromium.  My
builds are based on ChromeOS' browser.  That's how I get around it.

For more details...
https://codereview.chromium.org/16430003/

Sean


>
> Sean
>
>>
>> My previous i5-670 which was inferior in almost every other way didn't
>> have these problems.. It had the same 2560x1440 display.
>>
>>               Linus



-- 
Sean V. Kelley <sean.v.kelley@intel.com>
Open Source Technology Center / SSG
Intel Corp.
