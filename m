Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaHLLUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:20:11 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41816 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaHLLUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140812131407.069635e8@bbrezillon>
References: <1405173968-23869-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140812131407.069635e8@bbrezillon>
Date: Tue, 12 Aug 2014 07:20:09 -0400
Message-ID: <CAF6AEGuwrdaje9SrgjkgxGWS0zx0F+YYWkcGHDQubqUaq3zdSQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] drm: rework flip-work framework
From: Rob Clark <robdclark@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 7:14 AM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:
> Hi,
>
> On Sat, 12 Jul 2014 16:06:06 +0200
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
>
>> Hello,
>>
>> This patch series reworks the flip-work framework to make it safe when
>> calling drm_flip_work_queue from atomic contexts.
>>
>> The 2nd patch of this series is optional, as it only reworks
>> drm_flip_work_init prototype to remove unneeded size argument and
>> return code (this function cannot fail anymore).
>
>
> Atmel HLCDC driver now depends on this series and I'd like to get as
> much thing as possible for HLCDC support in 3.18 (if the driver can't
> make it for 3.18, at least the dependencies could).
>
> David, Rob (and other DRM/KMS developers) do you have any concern you
> would like addressed in this patch series ?

it already has my r-b :-)

BR,
-R

> Best Regards,
>
> Boris
>
>
> --
> Boris Brezillon, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
