Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab3EQXyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:54:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46259 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab3EQXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:54:43 -0400
Message-ID: <5196C340.2080706@wwwdotorg.org>
Date: Fri, 17 May 2013 17:54:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: dts: dalmore: enable spi4
References: <1365594483-20651-1-git-send-email-ldewangan@nvidia.com> <1365594483-20651-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1365594483-20651-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 05:48 AM, Laxman Dewangan wrote:
> Enable SPI4 and add Winbond SPI flash W25Q32DW device
> on CS0 line.

I have applied this to Tegra's for-3.11/dt branch.
