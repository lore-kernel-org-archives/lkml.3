Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3EQIe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:34:28 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:58215 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3EQIeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:34:24 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2013 04:34:24 EDT
X-IronPort-AV: E=Sophos;i="4.87,690,1363100400";   d="scan'208";a="127670047"
Message-id: <5195EA63.3050900@renesas.com>
Date: Fri, 17 May 2013 17:29:23 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509
 Thunderbird/17.0.6
MIME-version: 1.0
To: Laurent Navet <laurent.navet@gmail.com>
Cc: djbw@fb.com, vinod.koul@intel.com, kuninori.morimoto.gx@renesas.com,
        g.liakhovetski@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: dma: sh: sudmac: use devm_ioremap_resource()
References: <1368531330-32193-1-git-send-email-laurent.navet@gmail.com>
In-reply-to: <1368531330-32193-1-git-send-email-laurent.navet@gmail.com>
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2013/05/14 20:35), Laurent Navet wrote:
> Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
> Found with coccicheck and this semantic patch:
>  scripts/coccinelle/api/devm_ioremap_resource.cocci
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/dma/sh/sudmac.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thank you for the patch.

Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda
