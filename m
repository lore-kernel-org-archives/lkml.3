Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3GZTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:25:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58646 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3GZTZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:25:25 -0400
Message-ID: <51F2CD20.6030700@wwwdotorg.org>
Date: Fri, 26 Jul 2013 13:25:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Zhao <rizhao@nvidia.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        vinod.koul@intel.com, djbw@fb.com, broonie@kernel.org,
        gregkh@linuxfoundation.org, lgirdwood@gmail.com, linuxzsc@gmail.com,
        ldewangan@nvidia.com, dev@lynxeye.de
Subject: Re: [PATCH 0/9] ARM: tegra: move to generic DMA DT binding
References: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
In-Reply-To: <1374639002-16753-1-git-send-email-rizhao@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 10:09 PM, Richard Zhao wrote:
> The patch series aim to move apbdma to generic DT binding.
> 
> Changes:
> - It add dmas/dma-names properties while leave
>   nvidia,dma-request-selector to be compatible.
> - update apbdma driver and dma client drivers
> - ASoC tegra adds a new struct to pass device and dma-name.
> - at last, remove legacy nvidia,dma-request-selector

I would like to take this series through the Tegra tree to simplify
dependencies. So, I'm looking for ack's on the drivers rather than for
them to be applied. I had hoped Richard would point this out when
posting the patches.
