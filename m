Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaENP52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:57:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46293 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaENP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:57:26 -0400
Message-ID: <53739263.6080706@wwwdotorg.org>
Date: Wed, 14 May 2014 09:57:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH v2] ARM: tegra: enable joystick in tegra_defconfig
References: <1400033353-25673-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1400033353-25673-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 08:09 PM, Alexandre Courbot wrote:
> NVIDIA SHIELD embeds a USB joystick device. Enable the corresponding
> support in tegra_defconfig.

I've squashed this into Tegra's for-3.16/defconfig branch.
