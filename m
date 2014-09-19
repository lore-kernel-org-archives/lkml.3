Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbaISSZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:25:05 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:47756 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaISSZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:25:01 -0400
X-IronPort-AV: E=Sophos;i="5.04,556,1406617200"; 
   d="scan'208";a="46511300"
Message-ID: <541C74EB.9070100@broadcom.com>
Date: Fri, 19 Sep 2014 11:24:43 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <olof@lixom.net>, <arm@kernel.org>, <mporter@linaro.org>,
        <bcm@fixthebug.org>, <jonathar@broadcom.com>, <rjui@broadcom.com>,
        <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <hauke@hauke-m.de>,
        <swarren@wwwdotorg.org>, <computersforpeace@gmail.com>,
        <marc.ceeeee@gmail.com>, <cernekee@gmail.com>,
        <gregory.0xf0@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add a third maintainer to mach-bcm
References: <1411150632-25695-1-git-send-email-f.fainelli@gmail.com> <1411150632-25695-2-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1411150632-25695-2-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-09-19 11:17 AM, Florian Fainelli wrote:
> Add myself as a third maintainer to the mach-bcm code to increase the
> chances the redundancy in the merging/reviewing process.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Scott Branden <sbranden@broadcom.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 809ecd680d88..e0762fea2d02 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2004,6 +2004,7 @@ F:	drivers/net/ethernet/broadcom/bnx2x/
>   BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITECTURE
>   M:	Christian Daudt <bcm@fixthebug.org>
>   M:	Matt Porter <mporter@linaro.org>
> +M:	Florian Fainelli <f.fainelli@gmail.com>
>   L:	bcm-kernel-feedback-list@broadcom.com
>   T:	git git://github.com/broadcom/mach-bcm
>   S:	Maintained
>
