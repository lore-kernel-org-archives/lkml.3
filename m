Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaFPWBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:01:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44385 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaFPWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:01:05 -0400
Message-ID: <539F691E.5030204@wwwdotorg.org>
Date: Mon, 16 Jun 2014 16:01:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: thierry.reding@gmail.com
CC: Mikko Perttunen <mperttunen@nvidia.com>, tj@kernel.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> This symbol needs to be exported to power on rails without using
> tegra_powergate_sequence_power_up. tegra_powergate_sequence_power_up
> cannot be used in situations where the driver wants to handle clocking
> by itself.

Thierry, are you OK with this change?
