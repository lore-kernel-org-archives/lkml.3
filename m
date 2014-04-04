Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaDDPz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:55:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39094 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaDDPzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:55:54 -0400
Message-ID: <533ED607.1080700@wwwdotorg.org>
Date: Fri, 04 Apr 2014 09:55:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thierry Reding <treding@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] clk: tegra: Fix PLLE programming
References: <1396619715-15524-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1396619715-15524-1-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 07:55 AM, Thierry Reding wrote:
> PLLE has M, N and P divider shift and width parameters that differ from
> the defaults. Furthermore, when clearing the M, N and P divider fields
> the corresponding masks were never shifted, thereby clearing only the
> lowest bits of the register. This lead to a situation where the PLLE
> programming would only work if the register hadn't been touched before.

The series,
Acked-by: Stephen Warren <swarren@nvidia.com>

(I might have squashed patches 1 and 2 together, but no matter)

I expect these patches should be CC: stable when applied?
