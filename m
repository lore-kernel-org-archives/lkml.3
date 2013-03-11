Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3CKRlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:41:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51111 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3CKRlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:41:07 -0400
Message-ID: <513E1730.7040109@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:41:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, pdeschrijver@nvidia.com
Subject: Re: [PATCH V2 2/5] ARM: DT: tegra114: Add i2c controller DT entry
References: <1362852678-13421-1-git-send-email-ldewangan@nvidia.com> <1362852678-13421-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362852678-13421-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 11:11 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has 5 i2c controllers. These controllers have
> additional feature/configurations to make it functional over
> Tegra30's i2c controller driver.
> 
> Add DT entry for i2c controllers and make it compatible with
> "nvidia,tegra114-i2c".

Hmm. We're missing a binding document for the Tegra I2C module! Can you
please submit a separate patch to add one. When you do, since the
Tegra114 nodes need just a "div-clk" clock, and the Tegra20/30 nodes
need both div-clk and fast-clk, please be sure to mention this in the
document. Thanks.
