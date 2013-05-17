Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3EQXyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:54:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46346 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3EQXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:54:52 -0400
Message-ID: <5196C34A.9000303@wwwdotorg.org>
Date: Fri, 17 May 2013 17:54:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: config: tegra: enable T114 SPI
References: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 05:48 AM, Laxman Dewangan wrote:
> Nvidia Tegra114 has the new spi controller whose driver
> is not compatible with older SoCs. The new driver is added
> for Tegra114 spi controller.

I have applied this to (squashed it into) Tegra's for-3.11/defconfig branch.
