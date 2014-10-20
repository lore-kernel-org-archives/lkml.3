Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaJTQwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:52:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35310 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJTQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:52:30 -0400
Message-ID: <54453DE1.1020602@wwwdotorg.org>
Date: Mon, 20 Oct 2014 10:52:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vidya Sagar <vidyas@nvidia.com>, thierry.reding@gmail.com,
        bhelgaas@google.com
CC: kthota@nvidia.com, linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: tegra: Enable root port specific features
References: <1413803091-10824-1-git-send-email-vidyas@nvidia.com>
In-Reply-To: <1413803091-10824-1-git-send-email-vidyas@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 05:04 AM, Vidya Sagar wrote:
> Enables root port to advertise its ASPM-L1 capability
> resulting in possible link entry to L1 when an ASPM-L1 capable
> device is connected
> Enables per-controller & per-TMS clock clamping by default
> Enabling above features result in more power saving
>
> It also avoids PM message truncation by waiting for DLLP to finish
> before entering into L1 or L2

The updated tegra_pcie_enable() looks better in this patch, so that part,
Acked-by: Stephen Warren <swarren@nvidia.com>

I'll leave the review of the additional #defines and 
tegra_pcie_enable_rp_features() to Thierry.
