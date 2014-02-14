Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaBNQhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:37:43 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:35043 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaBNQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <1392390903-19826-1-git-send-email-mporter@linaro.org>
References: <1392390903-19826-1-git-send-email-mporter@linaro.org>
Date: Fri, 14 Feb 2014 08:37:41 -0800
Message-ID: <CAEPRUYqxHwSYVPV-1Td3dHsBydDybJh5YLY0+GoN+vnakGaTtw@mail.gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS: add additional ARM BCM281xx/BCM11xxx maintainer
From: Christian Daudt <bcm@fixthebug.org>
To: Matt Porter <mporter@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 7:15 AM, Matt Porter <mporter@linaro.org> wrote:
> Add myself as an additional maintainer for the Broadcom mobile
> SoCs.
>
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
> Since v1: put back my missing SOB
>
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2cf5cf..9d6fbfd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1860,6 +1860,7 @@ F:        drivers/net/ethernet/broadcom/bnx2x/
>
>  BROADCOM BCM281XX/BCM11XXX ARM ARCHITECTURE
>  M:     Christian Daudt <bcm@fixthebug.org>
> +M:     Matt Porter <mporter@linaro.org>
>  L:     bcm-kernel-feedback-list@broadcom.com
>  T:     git git://git.github.com/broadcom/bcm11351
>  S:     Maintained
> --
> 1.8.4
>
Acked-by: Christian Daudt <bcm@fixthebug.org>
