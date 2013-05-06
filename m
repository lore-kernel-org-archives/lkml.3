Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3EFTuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:50:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57859 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3EFTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:50:04 -0400
Message-ID: <51880966.9060503@wwwdotorg.org>
Date: Mon, 06 May 2013 13:49:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        ldewangan@nvidia.com, bhelgaas@google.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 09:41 AM, Jay Agarwal wrote:
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> 
> - Enable pcie root port 2 for cardhu
> - Make private data structure for each SOC
> - Add required tegra3 clocks and regulators
> - Add tegra3 specific code in enable controller
> - Modify clock tree to get clocks based on device
> - Based on git://gitorious.org/thierryreding/linux.git

Jay, I made quite a few comments on this series, and pointed out that it
didn't actually work for me. Are you planning on fixes these issues and
reposting?
