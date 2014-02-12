Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBLBiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:38:50 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47085 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaBLBis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:38:48 -0500
Date: Tue, 11 Feb 2014 17:38:46 -0800
From: Olof Johansson <olof@lixom.net>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH v2 0/6] ARM: firmware: improvements to Trusted
 Foundations support
Message-ID: <20140212013846.GB7584@quad.lixom.net>
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 01:35:00PM +0900, Alexandre Courbot wrote:
> These (mostly minor) patches fix a few typos, improve points that
> were agreed upon when the Trusted Foundation series was initially
> submitted, and more importantly add support for a prepare_idle()
> firmware operation that informs the firmware a CPU is doing idle.
> Tegra's cpuidle driver is then also updated accordingly.
> 
> These patches should be the last step before device trees for NVIDIA
> SHIELD and Tegra Note 7 can be submitted.
> 
> Changes since v1:
> - Do not remove TF support from tegra_defconfig (will automatically be taken
>   care of during next configuration update)
> - Add a new prepare_idle() operation to firmware_ops that informs the firmware
>   a CPU is going idle (vs. asking the firmware to do it itself as do_idle()
>   does)
> - Fix idle states names in TF implementation of prepare_idle to sound less
>   Tegra-specific

1-5:

Acked-by: Olof Johansson <olof@lixom.net>

Stephen asked if he should merge through Russell's tree or ours; since
tegra is the only user I don't have a problem merging this (via tegra
pull requests) but I'm giving Russell veto power. :)


-Olof
