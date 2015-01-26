Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbbAZKhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:37:40 -0500
Received: from smtp-out-156.synserver.de ([212.40.185.156]:1082 "EHLO
	smtp-out-156.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbbAZKhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:37:36 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29334
Message-ID: <54C618ED.1090909@metafoo.de>
Date: Mon, 26 Jan 2015 11:37:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, tiwai@suse.de,
        perex@perex.cz
CC: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/4] dt: sound: jz4740: Add binding documentation for
 jz4740-i2s
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-3-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1422267511-6649-3-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 11:18 AM, Zubair Lutfullah Kakakhel wrote:
[...]
> +Required properties:
> +- compatible : "ingenic,jz4740-i2s"
> +- reg : I2S registers location and length
> +- clocks : AIC and I2S PLL clock specifiers.
> +- clock-names: "aic" and "i2s"

We also need a handle to the DMA channels. Currently the request ids are 
hardcoded in the driver, but that needs to go away once the driver starts to 
support multiple SoCs with different request lines.
