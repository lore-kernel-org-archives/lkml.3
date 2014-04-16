Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161688AbaDPXQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:16:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55084 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161648AbaDPXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:16:48 -0400
Message-ID: <534F0F5D.3030904@wwwdotorg.org>
Date: Wed, 16 Apr 2014 17:16:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ARM: tegra: fix Venice2 SD card VQMMC supply
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org> <1397689719-28882-1-git-send-email-abrestic@chromium.org> <1397689719-28882-4-git-send-email-abrestic@chromium.org>
In-Reply-To: <1397689719-28882-4-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 05:08 PM, Andrew Bresticker wrote:
> VDDIO_SDMMC3 is the VQMMC (I/O) supply, not the VMMC (core) supply,
> for the SD slot on Venice2.

I've applied this (one patch) to Tegra's for-3.16/dt branch.
