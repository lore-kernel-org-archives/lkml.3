Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3HAHux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:50:53 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:38278 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3HAHuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:50:51 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130801172544.3129b9e0d0e3c855f5b6d5ba@canb.auug.org.au>
References: <20130801172544.3129b9e0d0e3c855f5b6d5ba@canb.auug.org.au>
Date: Thu, 1 Aug 2013 09:50:50 +0200
Message-ID: <CA+icZUU-mcv96gS8VLaMJ3szPR3pHFH8k2Ppu4WDmRu=kdOkYQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 9:25 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20130731:
>
> Removed trees: xen-arm (merged into the xen-tip tree)
>
> The ext4 tree still has its build failure so I used the version from
> next-20130726.
>
> The driver-core tree gained a conflict against the net-next tree.
>
> The usb-gadget tree lost its build failure but gained conflicts against
> Linus' tree.
>
> ----------------------------------------------------------------------------
>

Just FYI:
On some arches (like IA64) you will see a breakage in drm.
See pending "drm/mm: include required headers in drm_mm.h" patch in drm-next.

[1] https://patchwork.kernel.org/patch/2833468/
[2] http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=86e81f0e624b55fa9f1560c3b64bc80e458c5168
