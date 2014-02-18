Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaBRU46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:56:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53555 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBRU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:56:57 -0500
Message-ID: <5303C915.6060500@wwwdotorg.org>
Date: Tue, 18 Feb 2014 13:56:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v2 0/6] ARM: firmware: improvements to Trusted Foundations
 support
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 09:35 PM, Alexandre Courbot wrote:
> These (mostly minor) patches fix a few typos, improve points that
> were agreed upon when the Trusted Foundation series was initially
> submitted, and more importantly add support for a prepare_idle()
> firmware operation that informs the firmware a CPU is doing idle.
> Tegra's cpuidle driver is then also updated accordingly.
> 
> These patches should be the last step before device trees for NVIDIA
> SHIELD and Tegra Note 7 can be submitted.

I've applied this series to Tegra's for-3.15/tf branch (using V3 of
patch 6/6)
