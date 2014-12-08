Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaLHQSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:18:34 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:60602 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbaLHQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:18:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141208141750.GR20350@phenom.ffwll.local>
References: <1417976957-15049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20141208084228.GI20350@phenom.ffwll.local>
	<CA+gsUGSM43z6AXi0-evJni_fDX_=rjj6gBOCZmhLrqjyUhZeFg@mail.gmail.com>
	<20141208141750.GR20350@phenom.ffwll.local>
Date: Mon, 8 Dec 2014 14:18:30 -0200
Message-ID: <CA+gsUGRHkU4zdZSGer=Qr5LXMs7QeaFrhU2-1O5TiO76koO0cw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] gpu: drm: i915: intel_display.c: Remove
 unused function
From: Paulo Zanoni <przanoni@gmail.com>
To: Paulo Zanoni <przanoni@gmail.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Damien Lespiau <damien.lespiau@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-08 12:17 GMT-02:00 Daniel Vetter <daniel@ffwll.ch>:
> On Mon, Dec 08, 2014 at 10:32:49AM -0200, Paulo Zanoni wrote:
>> 2014-12-08 6:42 GMT-02:00 Daniel Vetter <daniel@ffwll.ch>:
>> > On Sun, Dec 07, 2014 at 07:29:17PM +0100, Rickard Strandqvist wrote:
>> >> Remove the function intel_output_name() that is not used anywhere.
>> >>
>> >> This was partially found by using a static code analysis program called cppcheck.
>> >>
>> >> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> >
>> > Queued for 3.20, thanks for the patch.
>>
>> This function was created for the "DDI personality" patches. We merged
>> the function but never ended up merging the patch containing the
>> callers...
>
> Oops, I've thought this is a renmant from the very first days of kms that
> somehow stuck around. That's what I get for once not using git blame
> excessively :( Want me to drop the patch again?

I am not opposed to the removal of an unused function: I understand
the value in the removal, and I also understand the reasons to keep
it. I was just pointing the reason of why we got here: we merged patch
1/2 but ended up never merging patch 2/2 because we always spot some
additional work required and it's a very low priority bug. If this
function is removed, the next person to try to ressurrect the ddi
personality patch can quickly resurrect it or even write a new
implementation from scratch. It is your decision :)


> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Paulo Zanoni
