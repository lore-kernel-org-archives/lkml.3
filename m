Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933Ab3JPW40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:56:26 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58327 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3JPW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:56:24 -0400
Message-ID: <525F1995.6060000@gmail.com>
Date: Wed, 16 Oct 2013 17:56:21 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Grant Likely <grant.likely@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] MAINTAINERS: Add Kumar to Device Tree Binding maintainers
 group
References: <1375977075-21674-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1375977075-21674-1-git-send-email-galak@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 10:51 AM, Kumar Gala wrote:
> I'm tossing my hat into the ring of maintainers/reviewers for device tree
> bindings based on history of dealing with DT on embedded PPC and starting
> work on ARM SoCs.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> ---

Seems this one got lost. I assume you still want to drink from the fire
hose, so I've applied it.

Rob

>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index defc053..fe7aac6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6062,6 +6062,7 @@ M:	Pawel Moll <pawel.moll@arm.com>
>  M:	Mark Rutland <mark.rutland@arm.com>
>  M:	Stephen Warren <swarren@wwwdotorg.org>
>  M:	Ian Campbell <ian.campbell@citrix.com>
> +M:	Kumar Gala <galak@codeaurora.org>
>  L:	devicetree@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/
> 

