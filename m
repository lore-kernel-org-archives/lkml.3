Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3GUS4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 14:56:14 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:45585 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab3GUS4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 14:56:13 -0400
Message-ID: <51EC2EC7.6010001@gmail.com>
Date: Sun, 21 Jul 2013 13:56:07 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org> <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 10:19 PM, Grant Likely wrote:
> Device tree bindings require a lot more attention than they used to.
> We've got a group of volunteers willing to take over maintaining
> bindings. This patch adds them to the MAINTAINERS file.
> 
> This group still needs to work out a process for maintainership and how
> they are going to work together. I recommend that they set up a shared
> tree on git.kernel.org that they each have commit access to similar to
> the tip tree or the arm-soc tree, but it is up to them.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: devicetree@vger.kernel.org
> ---
>  MAINTAINERS | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bc286e4..12c95d5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6050,13 +6050,24 @@ L:	devicetree@vger.kernel.org
>  W:	http://fdt.secretlab.ca
>  T:	git git://git.secretlab.ca/git/linux-2.6.git
>  S:	Maintained
> -F:	Documentation/devicetree
>  F:	drivers/of
>  F:	include/linux/of*.h
>  F:	scripts/dtc
>  K:	of_get_property
>  K:	of_match_table
>  
> +OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
> +M:	Pawel Moll <pawel.moll@arm.com>
> +M:	Mark Rutland <mark.rutland@arm.com>
> +M:	Stephen Warren <swarren@wwwdotorg.org>
> +M:	Ian Campbell <ian.campbell@citrix.com>

You can add me. I was not intending to step down.

What about creating an email alias for the group instead?

Rob

> +L:	devicetree@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree
> +F:	arch/*/boot/dts
> +F:	arch/*/
> +F:	include/dt-bindings
> +
>  OPENRISC ARCHITECTURE
>  M:	Jonas Bonn <jonas@southpole.se>
>  W:	http://openrisc.net
> 

