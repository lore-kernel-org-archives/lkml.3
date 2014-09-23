Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbaIWMsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:48:31 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43105 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbaIWMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:48:28 -0400
Date: Tue, 23 Sep 2014 08:48:23 -0400
From: Matt Porter <mporter@linaro.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net,
        arm@kernel.org, bcm@fixthebug.org, jonathar@broadcom.com,
        sbranden@broadcom.com, rjui@broadcom.com, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, hauke@hauke-m.de,
        swarren@wwwdotorg.org, computersforpeace@gmail.com,
        marc.ceeeee@gmail.com, cernekee@gmail.com, gregory.0xf0@gmail.com
Subject: Re: [PATCH] MAINTAINERS: add a third maintainer to mach-bcm
Message-ID: <20140923124823.GB12283@beef>
References: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com>
 <1411150632-25695-2-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411150632-25695-2-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:17:12AM -0700, Florian Fainelli wrote:
> Add myself as a third maintainer to the mach-bcm code to increase the
> chances the redundancy in the merging/reviewing process.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Matt Porter <mporter@linaro.org>

Thanks for offering to take the lead on this. With my change in role at
Linaro and lack of access to Broadcom documentation and tribal knowledge
on Broadcom mobile parts I can't do this justice any longer.

-Matt

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 809ecd680d88..e0762fea2d02 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2004,6 +2004,7 @@ F:	drivers/net/ethernet/broadcom/bnx2x/
>  BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITECTURE
>  M:	Christian Daudt <bcm@fixthebug.org>
>  M:	Matt Porter <mporter@linaro.org>
> +M:	Florian Fainelli <f.fainelli@gmail.com>
>  L:	bcm-kernel-feedback-list@broadcom.com
>  T:	git git://github.com/broadcom/mach-bcm
>  S:	Maintained
> -- 
> 1.9.1
> 
