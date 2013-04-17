Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3DQQSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 12:18:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4387 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3DQQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 12:18:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Apr 2013 09:16:27 -0700
Message-ID: <516ECA59.3050200@nvidia.com>
Date: Wed, 17 Apr 2013 21:44:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/3] regulator: palmas: add support for LDO8 tracking
 mode
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com> <1366191793-13934-3-git-send-email-ldewangan@nvidia.com> <516EA998.3050008@slimlogic.co.uk>
In-Reply-To: <516EA998.3050008@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 April 2013 07:24 PM, Graeme Gregory wrote:
> Looks good to me, I don't actually know the use case for this feature!
>
> Acked-by: Graeme Gregory <gg@slimlogic.co.uk>
>

This is require for Tegra.
The always ON section of Tegra (say vdd_ao) need to be same as the core 
voltage(vdd_core) when system is active/idle. Hence the vdd_ao should be 
track to vdd_core and for this we need to configure the rail in tracking 
mode.
