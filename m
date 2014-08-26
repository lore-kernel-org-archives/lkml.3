Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaHZRqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:46:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48791 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaHZRqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:46:45 -0400
Message-ID: <53FCC801.5000703@wwwdotorg.org>
Date: Tue, 26 Aug 2014 11:46:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tj@kernel.org, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 8/8] ARM: tegra: Add options for Tegra AHCI support
 to tegra_defconfig
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com> <1405500863-19696-9-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405500863-19696-9-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 02:54 AM, Mikko Perttunen wrote:
> This adds ATA, SATA_AHCI and AHCI_TEGRA support to tegra_defconfig
> so that the SATA support will be automatically enabled.

I've applied this to Tegra's for-3.18/dt branch.
