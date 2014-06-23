Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaFWSqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:46:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60676 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaFWSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:46:40 -0400
Message-ID: <53A8760D.8080106@wwwdotorg.org>
Date: Mon, 23 Jun 2014 12:46:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH 0/2] ARM: tegra: roth: pinmux fixes
References: <1403508779-25896-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1403508779-25896-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 01:32 AM, Alexandre Courbot wrote:
> Two small but important fixes to SHIELD's pinmux configuration.
> The use of invalid properties caused the pinmux to not be applied
> at all. Also the setting for sdmmc clock lines resulted in random
> errors or even the impossibility to probe attached devices.

It might be nice to add Roth's pinmux to:
https://github.com/NVIDIA/tegra-pinmux-scripts
