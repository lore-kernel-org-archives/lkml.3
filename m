Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3CKRne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:43:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51802 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3CKRnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:43:32 -0400
Message-ID: <513E17C1.1070305@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:43:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 4/5] ARM: DT: tegra114: add KBC controller DT entry
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <1362852678-13421-5-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362852678-13421-5-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 11:11 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 SoCs have the matrix keyboard controller which
> supports 11x8 type of matrix. The number of rows and columns
> are configurable.
> 
> Add DT entry for KBC controller with compatibility as "nvidia,tegra114-kbc",
> "nvidia,tegra20-kbc".

I thought the HW really wasn't compatible with Tegra20 due to the
reduced number of rows/columns/pins supported?
