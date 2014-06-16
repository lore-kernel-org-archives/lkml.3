Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaFPWEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:04:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60610 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFPWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:04:29 -0400
Message-ID: <539F69EA.6000200@wwwdotorg.org>
Date: Mon, 16 Jun 2014 16:04:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: tj@kernel.org
CC: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 7/9] ahci: Increase AHCI_MAX_CLKS to 4
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-8-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1401881559-18469-8-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> The Tegra AHCI device requires four clocks, so increase the maximum
> amount of handled clocks from three to four.

Tejun,

The SATA driver in patch 8/9 in this series would usually be applied in
your ATA tree. However, it has a lot of compile-time dependencies on
things outside the ATA tree that I expect you don't want to deal with.

If you're OK with patches 7 and 8, could you ack them so that I can
apply them to the Tegra tree?

I assume the patches won't cause any significant conflicts, but if you
need, I can certainly give you a signed tag back to allow you to merge
the driver patch (plus the compile-time dependencies) into your tree
later if needed.
