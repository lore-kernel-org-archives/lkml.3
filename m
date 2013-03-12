Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab3CLSBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:01:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37358 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3CLSB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:01:29 -0400
Message-ID: <513F6D74.8010107@wwwdotorg.org>
Date: Tue, 12 Mar 2013 12:01:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, hdoyu@nvidia.com, olof@lixom.net,
        gregkh@linuxfoundation.org, arnd@arndb.de, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 06:01 AM, Danny Huang wrote:
> Expose Tegra chip ID and revision in /sys/devices/soc for user mode
> usage

> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c

> +void __init tegra_soc_device_init(void)

Oh, and since this is exposing data that's initialized by Tegra's
fuse.c, wouldn't it make sense to put this function into fuse.c at the
end of its initialization function?
