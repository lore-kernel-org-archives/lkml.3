Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaLHMcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:32:51 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64336 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaLHMct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141208084228.GI20350@phenom.ffwll.local>
References: <1417976957-15049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20141208084228.GI20350@phenom.ffwll.local>
Date: Mon, 8 Dec 2014 10:32:49 -0200
Message-ID: <CA+gsUGSM43z6AXi0-evJni_fDX_=rjj6gBOCZmhLrqjyUhZeFg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] gpu: drm: i915: intel_display.c: Remove
 unused function
From: Paulo Zanoni <przanoni@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
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

2014-12-08 6:42 GMT-02:00 Daniel Vetter <daniel@ffwll.ch>:
> On Sun, Dec 07, 2014 at 07:29:17PM +0100, Rickard Strandqvist wrote:
>> Remove the function intel_output_name() that is not used anywhere.
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> Queued for 3.20, thanks for the patch.

This function was created for the "DDI personality" patches. We merged
the function but never ended up merging the patch containing the
callers...

> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx



-- 
Paulo Zanoni
