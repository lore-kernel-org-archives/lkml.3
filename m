Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3A2SKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:10:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47124 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3A2SKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:10:18 -0500
Message-ID: <51081087.5040801@wwwdotorg.org>
Date: Tue, 29 Jan 2013 11:10:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] ARM: DT: tegra114:add aliases and DMA requestor for
 serial controller
References: <1359464183-6255-1-git-send-email-ldewangan@nvidia.com> <1359464183-6255-7-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1359464183-6255-7-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 05:56 AM, Laxman Dewangan wrote:
> Add APB DMA requestor and serial aliases for serial controller.
> There will be two serial driver i.e. 8250 based simple serial driver
> and APB DMA based serial driver for higher baudrate and performace.
> 
> The simple serial driver get enabled with compatible nvidia,tegra20-uart
> and APB DMA based driver will get enabled with compatible
> nvidia,tegra30-hsuart.

I also can't apply this patch yet since it depends on the APB DMA DT
node which as I mentioned I'm not apply yet.
