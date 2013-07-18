Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3GRJm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:42:57 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:32916 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab3GRJms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <1374078552-10528-1-git-send-email-standby24x7@gmail.com>
References: <1374078552-10528-1-git-send-email-standby24x7@gmail.com>
Date: Thu, 18 Jul 2013 15:12:47 +0530
Message-ID: <CAK9yfHwXL31Cpm-1vtDMXED=geUa3L8+TCK+tqZ8AZ1mObRCVg@mail.gmail.com>
Subject: Re: [PATCH] [trivial] doc: Fix typo in doucmentations
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, rob@landley.net, linux-doc@vger.kernel.org,
        trivial@kernel.org, rdunlap@xenotime.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the patch title itself has a typo :)

s/doucmentations/documentations


On 17 July 2013 21:59, Masanari Iida <standby24x7@gmail.com> wrote:
> Correct typo (double words) in documentations.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/arm/OMAP/omap_pm                                   | 2 +-
>  Documentation/block/cfq-iosched.txt                              | 2 +-
>  Documentation/devicetree/bindings/arm/vexpress-sysreg.txt        | 4 ++--
>  Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt | 2 +-
>  Documentation/dma-buf-sharing.txt                                | 2 +-
>  Documentation/fb/fbcon.txt                                       | 2 +-
>  Documentation/fb/viafb.txt                                       | 2 +-
>  Documentation/filesystems/ext4.txt                               | 2 +-
>  Documentation/filesystems/nfs/pnfs.txt                           | 2 +-
>  Documentation/filesystems/relay.txt                              | 2 +-
>  Documentation/filesystems/sysfs-tagging.txt                      | 2 +-
>  Documentation/i2c/upgrading-clients                              | 4 ++--
>  Documentation/rapidio/rapidio.txt                                | 2 +-
>  Documentation/sound/alsa/compress_offload.txt                    | 2 +-
>  Documentation/sysfs-rules.txt                                    | 2 +-
>  Documentation/virtual/kvm/api.txt                                | 2 +-
>  Documentation/x86/boot.txt                                       | 2 +-
>  17 files changed, 19 insertions(+), 19 deletions(-)


-- 
With warm regards,
Sachin
