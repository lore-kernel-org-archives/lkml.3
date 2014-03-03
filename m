Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaCCRAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:00:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56281 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaCCRAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:00:47 -0500
Message-ID: <5314B53B.4010107@wwwdotorg.org>
Date: Mon, 03 Mar 2014 10:00:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393818596-26775-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1393818596-26775-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 08:49 PM, Alexandre Courbot wrote:
> Add a device tree for NVIDIA SHIELD. The set of enabled features is
> still minimal with no display option and USB requiring external power.
> 
> A default kernel command-line as well as initrd addresses are hardcoded
> to match the static values the bootloader is known to use. This allows
> booting from an appended DTB without having to alter it at boot time,
> since the bootloader has no Device Tree support.

This and the TN7 patch look fine. Hopefully I'll apply them soon,
pending the ti,irq-externally-inverted discussion.

> +	/* SD card */

Oh, that's all you meant by wanting to add comments? I guess I just
recognize SD-vs-eMMC by the bus width, but adding the comments is a good
idea.
