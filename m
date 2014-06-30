Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaF3UWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:22:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56310 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaF3UWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:22:09 -0400
Message-ID: <53B1C6EC.7070907@wwwdotorg.org>
Date: Mon, 30 Jun 2014 14:22:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 0/6] regulator: palmas: cleanup and fixes
References: <1404143859-8160-1-git-send-email-nm@ti.com>
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 09:57 AM, Nishanth Menon wrote:
> Hi,
> 	Original thread (v1): http://marc.info/?t=140380766500004&r=1&w=2
> This series is based on: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
> branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)
> 
> This series does a few cleanups to help ensure we dont make typo mistakes and finally provides a fix as attempted by (v1).
> 
> Basic cpufreq tests performed on OMAP5uEVM, DRA7-evm, DRA72-evm all of which are palmas variants.
> 
> The patches are also available here: https://github.com/nmenon/linux-2.6-playground/commits/broonie-topic-palmas-fixes

The series,
Tested-by: Stephen Warren <swarren@nvidia.com>

(An NVIDIA Dalmore board boots and shuts down OK with these applied on
top of next-20140630, and various peripherals such as LCD panel, audio,
USB, and SPI flash all work)
