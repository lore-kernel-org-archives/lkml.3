Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaG3Kng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:43:36 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51803 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaG3Kne convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+M3ks5A_aacyDjcAGRPNw1xw82YQJJGwHkZQeY8zvtd6=t1BQ@mail.gmail.com>
References: <1403081488-13114-1-git-send-email-benjamin.gaignard@linaro.org>
	<CAF6AEGsLbmos9nz-AYv2v0g33BYdAgKYTe8_ihDWEF3GK_=gjQ@mail.gmail.com>
	<20140703215200.GG32514@n2100.arm.linux.org.uk>
	<CAF6AEGsAtqCjrvrgcXmOY0nie89ppFHBcRPtt36ESHWBNqobTg@mail.gmail.com>
	<CA+M3ks4BU3MTaeCeMPbu8LqW=H27ZAdF-qZLUiG3UXJzbA89Fw@mail.gmail.com>
	<CA+M3ks5osUkkEY64t=M1zEp7DA5rn+MxxqiJhQm5QiEFUPBL+A@mail.gmail.com>
	<CA+M3ks7-ZHghELcRHDiFNbubDZ2DRQPDh2bKKzhsu4EcA0Tzcg@mail.gmail.com>
	<CAF6AEGupwP4aq7EG2SdRUAwy-dzab7fVd2SSoHfGpX8o6yR+WQ@mail.gmail.com>
	<CAPM=9tyKWbffCrUP+3VETEcqAvMG-5+wkW7Rg09BGDnbO=jsBw@mail.gmail.com>
	<CA+M3ks7dfE9nfH6J++fB897PJ407amuxU_g6As-xzPzddTgArw@mail.gmail.com>
	<CAPM=9twxj3KsdqqdeP2S_TyMUDHs5aYHExWC3FyTm=+n153Liw@mail.gmail.com>
	<CA+M3ks5A_aacyDjcAGRPNw1xw82YQJJGwHkZQeY8zvtd6=t1BQ@mail.gmail.com>
Date: Wed, 30 Jul 2014 12:43:33 +0200
Message-ID: <CA+M3ks5=s33dZ_uz4G+sK+Ckv7CxH11fhDpYG8JAAkHb5kh66Q@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] Add DRM for stih4xx platforms
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have push two additional patches on drm_kms_for_next-v7 branch to
make the driver build as a module:
- "gpu: drm: export drm_sysfs_connector_{add,remove} function"
- "drm: sti: Allow driver to be built as module"

I have tested the both configuration (built-in and module), it is ok
on my hardware.

Regards,
Benjamin


2014-07-30 8:46 GMT+02:00 Benjamin Gaignard <benjamin.gaignard@linaro.org>:
>
> Le mercredi 30 juillet 2014, Dave Airlie <airlied@gmail.com> a écrit :
>
>> On 28 July 2014 18:37, Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> wrote:
>> > Hello Dave,
>> >
>> > You can found the patcheset with Rob's reviewed-by tag here:
>> > git://git.linaro.org/people/benjamin.gaignard/kernel.git
>> > on drm_kms_for_next-v7 branch
>> >
>> > It is the same code (drm_kms_for_next-v6) than what Rob has reviewed,
>> > rebased (and tested) on top of drm-next.
>> > The only changes are clocks typo (upper to lower case) in binding
>> > documentation.
>>
>> Any reason this can't be built as a module?
>>
>> Since distros really don't want to have to build in graphics drivers,
>> and it makes
>> my test builds more annoying.
>>
>> Dave.
>
>
> No specific reason but I haven't test it as a module.
>
>
>
> --
>
> Benjamin Gaignard
>
> Graphic Working Group
>
> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro: Facebook | Twitter | Blog
>
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
