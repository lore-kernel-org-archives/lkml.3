Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaG0XXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:23:13 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36057 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaG0XXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGupwP4aq7EG2SdRUAwy-dzab7fVd2SSoHfGpX8o6yR+WQ@mail.gmail.com>
References: <1403081488-13114-1-git-send-email-benjamin.gaignard@linaro.org>
	<CAF6AEGsLbmos9nz-AYv2v0g33BYdAgKYTe8_ihDWEF3GK_=gjQ@mail.gmail.com>
	<20140703215200.GG32514@n2100.arm.linux.org.uk>
	<CAF6AEGsAtqCjrvrgcXmOY0nie89ppFHBcRPtt36ESHWBNqobTg@mail.gmail.com>
	<CA+M3ks4BU3MTaeCeMPbu8LqW=H27ZAdF-qZLUiG3UXJzbA89Fw@mail.gmail.com>
	<CA+M3ks5osUkkEY64t=M1zEp7DA5rn+MxxqiJhQm5QiEFUPBL+A@mail.gmail.com>
	<CA+M3ks7-ZHghELcRHDiFNbubDZ2DRQPDh2bKKzhsu4EcA0Tzcg@mail.gmail.com>
	<CAF6AEGupwP4aq7EG2SdRUAwy-dzab7fVd2SSoHfGpX8o6yR+WQ@mail.gmail.com>
Date: Mon, 28 Jul 2014 09:23:10 +1000
Message-ID: <CAPM=9tyKWbffCrUP+3VETEcqAvMG-5+wkW7Rg09BGDnbO=jsBw@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] Add DRM for stih4xx platforms
From: Dave Airlie <airlied@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 04:33, Rob Clark <robdclark@gmail.com> wrote:
> On Tue, Jul 15, 2014 at 5:41 AM, Benjamin Gaignard
> <benjamin.gaignard@linaro.org> wrote:
>> Hi all,
>>
>> Does version 6 fit to all your expectations ?
>> If yes will you consider to merge it into drm-next ?
>> If no, please tell me what need to be fixed.
>
>
> I had another pass over the driver, and didn't find anything to
> complain about, so for the series:
>
> Reviewed-by: Rob Clark <robdclark@gmail.com>

Can I see a git tree of this with Rob's R-B on it?

based off drm-next if possible,

I'd like to do a quick pre-merge review of it, but I usually don't
find anything too major.

Dave.
