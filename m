Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3LCMvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:51:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab3LCMvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:51:43 -0500
Date: Tue, 3 Dec 2013 14:55:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mark Brown <broonie@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        virtualization@lists.linux-foundation.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] virtio: Update spec address
Message-ID: <20131203125505.GA32687@redhat.com>
References: <1386074421-20662-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386074421-20662-1-git-send-email-broonie@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 12:40:21PM +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> According to the README at the existing URL the spec has moved to github
> so update the documentation to match.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>

Even that's no longer accurate :)
There should be a new address RSN, I'll respond.

> ---
>  Documentation/devicetree/bindings/virtio/mmio.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/virtio/mmio.txt b/Documentation/devicetree/bindings/virtio/mmio.txt
> index 5069c1b8e193..0648851d2a25 100644
> --- a/Documentation/devicetree/bindings/virtio/mmio.txt
> +++ b/Documentation/devicetree/bindings/virtio/mmio.txt
> @@ -1,6 +1,6 @@
>  * virtio memory mapped device
>  
> -See http://ozlabs.org/~rusty/virtio-spec/ for more details.
> +See https://github.com/rustyrussell/virtio-spec for more details.
>  
>  Required properties:
>  
> -- 
> 1.8.5
