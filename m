Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaEGP5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:57:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41804 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbaEGP5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:57:49 -0400
Message-ID: <536A57FA.2090608@wwwdotorg.org>
Date: Wed, 07 May 2014 09:57:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: enable console framebuffer rotation
References: <1399432682-677-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1399432682-677-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 09:18 PM, Alexandre Courbot wrote:
> Console rotation is needed for devices like Tegra Note 7 and NVIDIA
> SHIELD to get the boot console in the expected orientation.

I've squashed this into Tegra's for-3.16/defconfig branch.

Can you please also update multi_v7_defconfig, and send that change to
arm-soc (arm@kernel.org) to be applied. Thanks.
