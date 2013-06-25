Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3FYKef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:34:35 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12437 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FYKee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:34:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Jun 2013 03:34:33 -0700
Message-ID: <51C9739A.8050403@nvidia.com>
Date: Tue, 25 Jun 2013 16:10:26 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] regulator: palmas: model SMPS10 as two regulators
References: <1372150828-10519-1-git-send-email-kishon@ti.com>
In-Reply-To: <1372150828-10519-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 June 2013 02:30 PM, Kishon Vijay Abraham I wrote:
> SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
> SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
> in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2 configures
> it in BOOST mode. For BYPASS mode regulator_allow_bypass() API can be
> used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be enabled using
> regulator_enable().
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>

Looks good to me.

My sign-off is already there but in case:
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
Tested-by: Laxman Dewangan <ldewangan@nvidia.com>
