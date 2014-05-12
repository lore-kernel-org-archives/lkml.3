Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbaELQc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:32:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60376 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaELQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:32:23 -0400
Message-ID: <5370F794.2020800@wwwdotorg.org>
Date: Mon, 12 May 2014 10:32:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 1/2] ARM: tegra: joystick input in tegra_defconfig
References: <1399883209-31169-1-git-send-email-acourbot@nvidia.com> <1399883209-31169-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1399883209-31169-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 02:26 AM, Alexandre Courbot wrote:
> NVIDIA SHIELD embeds a USB controller. Compile the corresponding support

USB controller or USB joystick?

> as a module in tegra_defconfig.

Why make this a module rather than built-in. Almost everything else in
tegra_defconfig is built-in, except brcmfmac since it doesn't handle
lack of firmware availability at probe time.
