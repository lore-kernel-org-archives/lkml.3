Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaGVXmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:42:13 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:57144 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbaGVXmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:42:12 -0400
MIME-Version: 1.0
In-Reply-To: <1405977438-15517-1-git-send-email-marek@goldelico.com>
References: <1405977438-15517-1-git-send-email-marek@goldelico.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 22 Jul 2014 16:41:49 -0700
Message-ID: <CAK5ve-+7K0maC9J2zfOW1U8=UGwbNPTKUBaQe6GgXyvY6VJhrA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: dts: tcs6507: Fix wrong statement about #gpio-cells
To: Marek Belisko <marek@goldelico.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 2:17 PM, Marek Belisko <marek@goldelico.com> wrote:
> Update comment about gpio-cells which says not correctly to be set to 0.
> When we want to reference tca6507 gpio #gpio-cells must be set to 2 (it is
> already correct in example).
>

Good fix. I applied it
Thanks,
-Bryan

> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  Documentation/devicetree/bindings/leds/tca6507.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
> index d7221b8..bad9102 100644
> --- a/Documentation/devicetree/bindings/leds/tca6507.txt
> +++ b/Documentation/devicetree/bindings/leds/tca6507.txt
> @@ -8,7 +8,7 @@ Required properties:
>
>  Optional properties:
>  - gpio-controller: allows lines to be used as output-only GPIOs.
> -- #gpio-cells: if present, must be 0.
> +- #gpio-cells: if present, must not be 0.
>
>  Each led is represented as a sub-node of the ti,tca6507 device.
>
> --
> 1.9.1
>
