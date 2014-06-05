Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaFER3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:29:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37051 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaFER3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:29:32 -0400
Message-ID: <5390A8F9.2090408@wwwdotorg.org>
Date: Thu, 05 Jun 2014 11:29:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        tj@kernel.org, pdeschrijver@nvidia.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> Hi,
> 
> This series adds support for the onboard AHCI-compliant Serial ATA
> controller found on Tegra124 systems-on-chip. The controller is
> enabled on Jetson TK1. The series depends on Peter's efuse series 
> and Thierry's yet to be submitted XUSB pinctrl driver.

This series includes patches to a lot of different subsystems. That will
complicate applying it.

Can you write a summary of the *compile time* dependencies, since that
will influence how the patches get merged.

You mentioned that this series depends on efuse and XUSB padctl. Can you
point out which specific parts of this series depend on which of those
two other series, and whether this is a compile-time or run-time dependency.

I hope that the drivers/ata patches, drivers/clk patches, DT, and
defconfig patches can each be applied to their normal tree and don't
depend on each-other at compile-time at all.

At run-time, obviously all the patches are needed to make the code work,
but since this is a new feature, it's fine if this all only works once
everything is merged together in linux-next or Linus's tree.

Thanks.
