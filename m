Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043AbaH0Q0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:26:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36941 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaH0Q0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:26:19 -0400
Message-ID: <53FE06A9.4090509@wwwdotorg.org>
Date: Wed, 27 Aug 2014 10:26:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, linux@arm.linux.org.uk,
        olof@lixom.net, swarren@nvidia.com
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Enable Tegra AHCI driver
References: <1409122275-16464-1-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1409122275-16464-1-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 12:51 AM, Mikko Perttunen wrote:
> This enables AHCI_TEGRA by default. This driver is required
> for Serial ATA support on Tegra124-based boards.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
