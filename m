Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334Ab3BLPUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:20:10 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10099 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3BLPUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:20:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 12 Feb 2013 07:20:07 -0800
Message-ID: <511A5D93.1040101@nvidia.com>
Date: Tue, 12 Feb 2013 20:49:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: initialise parent of uart clocks
References: <1360682233-23016-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1360682233-23016-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013 08:47 PM, Laxman Dewangan wrote:
> Initialise the parent of UARTs to PLLP and disabling clock by
> default.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---

Please ignore this, I just sent the other patch as V2 to have more 
appropriate version. Please review the Patch V2.
Sorry for spam/inconvenience.

