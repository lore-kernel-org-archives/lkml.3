Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3CKRT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:19:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59165 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3CKRT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:19:26 -0400
Message-ID: <513E121B.60401@wwwdotorg.org>
Date: Mon, 11 Mar 2013 11:19:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: akpm@linux-foundation.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, thierry.reding@avionic-design.de
Subject: Re: [PATCH V2 0/5] rtc: tegra: cleanups to remove warning/code lines
References: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1362991468-30226-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 02:44 AM, Laxman Dewangan wrote:
> This patch series does the cleanups in the rtc driver as follows:
> - Protect suspend/resume with CONFIG_PM_SLEEP.
> - Use dev_pm_ops in place of legacy way for suspend/resume.
> - Properly reflect teh irq name when doing cat /proc/interrupts.
> - Use module_platform_probe() to remove boilerplate code.
> - use devm_rtc_device_register.

Assuming there's a good explanation for my question re: patch 3/5, then
the series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>
