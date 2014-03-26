Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaCZUF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:05:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52548 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbaCZUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:05:27 -0400
Message-ID: <53333303.70709@wwwdotorg.org>
Date: Wed, 26 Mar 2014 14:05:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>, arm@kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: enable fhandle in tegra_defconfig
References: <1395800972-26483-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1395800972-26483-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 08:29 PM, Alexandre Courbot wrote:
> CONFIG_FHANDLE is required by systemd >= 210 to spawn a serial TTY.

The series,
Acked-by: Stephen Warren <swarren@nvidia.com>

Patch 1/2,
Tested-by: Stephen Warren <swarren@nvidia.com>
(although not with the new systemd version that requires the change, but
rather for regressions in Ubuntu 12.04)

