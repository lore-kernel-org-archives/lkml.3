Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3E1Cbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:31:45 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38102 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3E1Cbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4Qa6g-zrA6o_u3w6mpVcUk8-ZPPR+edu6EXgpk-kGQULQ@mail.gmail.com>
References: <1369626821-28494-1-git-send-email-acourbot@nvidia.com> <CANq1E4Qa6g-zrA6o_u3w6mpVcUk8-ZPPR+edu6EXgpk-kGQULQ@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 28 May 2013 11:31:22 +0900
Message-ID: <CAAVeFuJssMGNi=7gtxHjgaS9s+VTkfBme+T68=Zf7Ech2+hMQw@mail.gmail.com>
Subject: Re: [PATCH v2] video: simplefb: add mode parsing function
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Rob Clark <robclark@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rpi-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, May 28, 2013 at 3:22 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> If we apply this patch it will get very hard to support this with a
> KMS driver. So any reason why we cannot use the DRM FOURCC constants
> instead?

I don't see any. Maybe Stephen can confirm.

> The dvbe proposal is available here: (also see the two following patches)
>   http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/00274.html
>
> it provides a simple DRM driver that uses VESA / VBE. I am currently
> trying to rework it to "SimpleDRM" which can support arbitrary
> firmware framebuffers.

Ok. I am personally fine with using FOURCC codes for describing video
modes. Maybe we can just drop this patch if it gets in your way.

Alex.
