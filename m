Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3JQMPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:15:10 -0400
Received: from muin.pair.com ([209.68.1.55]:61419 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab3JQMPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:15:08 -0400
Message-ID: <525FD4C7.3050806@tabi.org>
Date: Thu, 17 Oct 2013 07:15:03 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Firefox/24.0 SeaMonkey/2.21
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        lgirdwood@gmail.com, broonie@kernel.org
CC: r64188@freescale.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, linux@arm.linux.org.uk, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, fabio.estevam@freescale.com,
        LW@KARO-electronics.de, oskar@scara.com, shawn.guo@linaro.org,
        b42378@freescale.com, b18965@freescale.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCHv1 1/8] ALSA: Add SAI SoC Digital Audio Interface driver.
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com> <1382000477-17304-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1382000477-17304-2-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiubo Li wrote:
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	sai->base = devm_ioremap_resource(&pdev->dev, res);

Why not use of_iomap()?
