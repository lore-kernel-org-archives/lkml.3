Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaEAR0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:26:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33207 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaEAR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:26:43 -0400
Message-ID: <536283CF.2020304@wwwdotorg.org>
Date: Thu, 01 May 2014 11:26:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>,
        linux-mtd@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 04/12] ARM: tegra: add MTD_SPI_NOR (new dependency
 for M25P80)
References: <1398925607-7482-1-git-send-email-computersforpeace@gmail.com> <1398925607-7482-5-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1398925607-7482-5-git-send-email-computersforpeace@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 12:26 AM, Brian Norris wrote:
> This defconfig contains the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to satisfy
> the new dependency.

Squashed into Tegra's for-3.16/defconfig branch.

