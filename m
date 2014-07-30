Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaG3BGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:06:09 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:62259 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaG3BGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+M3ks7dfE9nfH6J++fB897PJ407amuxU_g6As-xzPzddTgArw@mail.gmail.com>
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
Date: Wed, 30 Jul 2014 11:06:05 +1000
Message-ID: <CAPM=9twxj3KsdqqdeP2S_TyMUDHs5aYHExWC3FyTm=+n153Liw@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] Add DRM for stih4xx platforms
From: Dave Airlie <airlied@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2014 18:37, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
> Hello Dave,
>
> You can found the patcheset with Rob's reviewed-by tag here:
> git://git.linaro.org/people/benjamin.gaignard/kernel.git
> on drm_kms_for_next-v7 branch
>
> It is the same code (drm_kms_for_next-v6) than what Rob has reviewed,
> rebased (and tested) on top of drm-next.
> The only changes are clocks typo (upper to lower case) in binding documentation.

Any reason this can't be built as a module?

Since distros really don't want to have to build in graphics drivers,
and it makes
my test builds more annoying.

Dave.
