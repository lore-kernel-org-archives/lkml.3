Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3CSRf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:35:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38822 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab3CSRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:35:25 -0400
Message-ID: <5148A1DA.6040304@wwwdotorg.org>
Date: Tue, 19 Mar 2013 11:35:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: rob@landley.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Doc: dt: i2c: tegra: add dt binding for i2c-tegra
References: <1363599350-25187-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363599350-25187-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 03:35 AM, Laxman Dewangan wrote:
> Add documentation for device tree binding of NVIDIA's Tegra i2c
> controller driver.
> 
> Describing all compatible values used for diffenent Tegra SoCs
> in details in this documentation.

I have applied this to Tegra's for-3.10/dt branch. I fixed a couple of
typos and capitalization errors. I also trimmed the patch to include
only a single example; the description in the text is enough to get the
rest right, so there's no need to include exhaustive examples.
