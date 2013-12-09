Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397Ab3LISAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:00:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34130 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3LISAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:00:50 -0500
Message-ID: <52A6054F.4080103@wwwdotorg.org>
Date: Mon, 09 Dec 2013 11:00:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] spi: tegra: use u32 for 32-bit register values
References: <1385745164-10534-1-git-send-email-mpn@google.com> <1386516911-26388-1-git-send-email-mina86@mina86.com>
In-Reply-To: <1386516911-26388-1-git-send-email-mina86@mina86.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 08:35 AM, Michal Nazarewicz wrote:
> This series has only been compile-tested, but it does not introduce any
> behaviour changes.

The series,
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

... although I will observe that the patch subjects, and even patch
descriptions, don't describe all the other unrelated code
transformations that are rolled into these patches...
