Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3LPS3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:29:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37488 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3LPS3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:29:40 -0500
Message-ID: <52AF468E.1050602@wwwdotorg.org>
Date: Mon, 16 Dec 2013 11:29:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>, swarren@nvidia.com, will.deacon@arm.com,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        robherring2@gmail.com, joro@8bytes.org
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        lorenzo.pieralisi@arm.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, galak@codeaurora.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv7 01/12] of: introduce of_property_for_each_phandle_with_args()
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com> <1386835033-4701-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1386835033-4701-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 12:57 AM, Hiroshi Doyu wrote:
> Iterating over a property containing a list of phandles with arguments
> is a common operation for device drivers. This patch adds a new
> of_property_for_each_phandle_with_args() macro to make the iteration
> simpler.

This version looks good to me.
Reviewed-by: Stephen Warren <swarren@nvidia.com>

But if you want to rewrite it to use a struct to store state between
_init()/_iter(), that'd probably be fine too.
