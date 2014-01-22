Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaAVUrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:47:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55672 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaAVUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:47:10 -0500
Message-ID: <52E02E4B.5060206@wwwdotorg.org>
Date: Wed, 22 Jan 2014 13:47:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH 0/5] ARM: firmware: improvements to Trusted Foundations
 support
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
> These (mostly minor) patches fix a few typos, improve points that
> were agreed upon when the Trusted Foundation series was initially
> submitted, and more importantly add support for the do_idle() firmware
> operation that is needed for cpuidle to be supported. Tegra's cpuidle
> driver is also updated accordingly.
> 
> These patches should be the last step before the device trees for NVIDIA
> SHIELD and Tegra Note 7 can be submitted.

Russell, once these patches are reviewed, should Alex submit them to the
ARM patch tracker, or will you Ack them so they can go through the Tegra
tree? Either way I can put them in a separate branch based on 3.14-rc1
in order to easily resolve any conflicts.
