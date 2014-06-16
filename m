Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaFPVtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:49:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40779 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbaFPVtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:49:21 -0400
Message-ID: <539F665E.3060007@wwwdotorg.org>
Date: Mon, 16 Jun 2014 15:49:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: pdeschrijver@nvidia.com
CC: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        tj@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/9] clk: tegra: Enable hardware control of SATA PLL
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <1401881559-18469-5-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1401881559-18469-5-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> This makes the SATA PLL be controlled by hardware instead of software.
> This is required for working SATA support.

Peter, could you please take patches 4 and 5 through the clock tree. As
far as I can tell, there's no compile-time dependency in the clock
patches, so they can go through a different tree to the rest of the
series without issue. These 2 patches look fine to me, so consider them:

Acked-by: Stephen Warren <swarren@nvidia.com>
