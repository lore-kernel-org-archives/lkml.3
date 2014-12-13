Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaLMW1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 17:27:10 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39848 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaLMW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 17:27:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141212071340.GC3362@verge.net.au>
References: <CAPM=9tw6DmAU0rwPzTO=yPt5s6xLMTP=VuyPR7ObtkFNquf5HA@mail.gmail.com>
	<20141212071340.GC3362@verge.net.au>
Date: Sat, 13 Dec 2014 14:27:08 -0800
X-Google-Sender-Auth: nrmd7X5sOZiNIqOCwJhYbKyqPAU
Message-ID: <CA+55aFxmVHCUxcv+Fzb-vSvmMoYeQswBKiuuPHDcTw4p7Wbidg@mail.gmail.com>
Subject: Re: drm pull waiting on other trees
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: Dave Airlie <airlied@gmail.com>, Joerg Roedel <jroedel@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:13 PM, Simon Horman <horms@verge.net.au> wrote:
>
> If you give me a specific tag or commit id I can investigate further but
> I'm assuming it is renesas-dt-du-for-v3.19 (0ee56d403549fd97d) then it has
> been accepted by the by Arnd (CCed) and I believe he or one of the other
> Arm SoC maintainers (also CCed) have a plan to submit it to Linus (most
> likely as part of a larger pull-request).

That commit is in my tree, and has been for a few days.

The IOMMU tree was also merged yesterday, so hopefully everything drm
needs is there now,

                   Linus
