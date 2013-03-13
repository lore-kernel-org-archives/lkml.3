Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029Ab3CMRqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:46:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44456 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778Ab3CMRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:45:55 -0400
Message-ID: <5140BB50.8080004@wwwdotorg.org>
Date: Wed, 13 Mar 2013 11:45:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux@arm.linux.org.uk, ldewangan@nvidia.com, olof@lixom.net,
        hdoyu@nvidia.com, thierry.reding@avionic-design.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3] ARM: tegra: expose chip ID and revision
References: <1363168080-12697-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363168080-12697-1-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 03:48 AM, Danny Huang wrote:
> Expose Tegra chip ID and revision in /sys/devices/soc for user mode
> usage

> diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c

>  static void __init tegra_dt_init(void)
>  {
> +	struct device *parent = NULL;
> +	struct soc_device *soc_dev;
> +	struct soc_device_attribute *soc_dev_attr;

Since Russell asked you to redo the patch anyway, I'd prefer that
variables be declared in the order they're used. So, soc_dev_attr, then
soc_dev, then parent.
