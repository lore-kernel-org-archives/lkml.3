Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaLYCF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 21:05:57 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14051 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaLYCFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 21:05:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 24 Dec 2014 18:04:12 -0800
Message-ID: <549B70EA.7050903@nvidia.com>
Date: Thu, 25 Dec 2014 10:05:30 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>, <thierry.reding@gmail.com>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com> <1419331204-26679-2-git-send-email-vinceh@nvidia.com> <549AC511.5040507@gmail.com>
In-Reply-To: <549AC511.5040507@gmail.com>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 drhkmail101.nvidia.com (10.25.59.15)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 09:52 PM, Dmitry Osipenko wrote:
> I think "ARM: tegra:" is wrong prefix for this patch and "soc: tegra:" should be
> used instead to show that it belongs to SoC driver, not arch code.
Indeed. Will fix in v2.

Thanks,
Vince

