Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3GQRBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:01:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab3GQRBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:01:12 -0400
Message-ID: <51E6CDA8.50206@infradead.org>
Date: Wed, 17 Jul 2013 10:00:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-kernel@vger.kernel.org, rob@landley.net, linux-doc@vger.kernel.org,
        trivial@kernel.org, rdunlap@xenotime.net
Subject: Re: [PATCH] [trivial] doc: Fix typo in doucmentations
References: <1374078552-10528-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1374078552-10528-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/13 09:29, Masanari Iida wrote:
> Correct typo (double words) in documentations.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

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
~Randy
