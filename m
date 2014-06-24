Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaFXTgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:36:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58793 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFXTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:36:00 -0400
Message-ID: <53A9D31A.6030307@wwwdotorg.org>
Date: Tue, 24 Jun 2014 13:35:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, tj@kernel.org
CC: thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com> <1403101406-15439-7-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1403101406-15439-7-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 08:23 AM, Mikko Perttunen wrote:
> This adds support for the integrated AHCI-compliant Serial ATA
> controller present on the NVIDIA Tegra124 system-on-chip.

At a quick glance, this looks fine to me now. I'll wait for an ack to
take this patch through the Tegra tree, for the reasons I mentioned in
response to v1.
