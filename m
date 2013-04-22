Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3DVM2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:28:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18442 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3DVM2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:28:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 22 Apr 2013 05:28:10 -0700
Message-ID: <51752BD9.2020707@nvidia.com>
Date: Mon, 22 Apr 2013 17:53:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] regulator: palmas: Fix off-by-one for ramp_delay
 and register value mapping
References: <1366626169.3800.1.camel@phoenix>
In-Reply-To: <1366626169.3800.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013 03:52 PM, Axel Lin wrote:
> Datasheet says:
> Time Step (TSTEP) selection, when changing the output voltage, the new value is
> reached through successive voltage steps (if not bypassed). The equivalent
> programmable slew rate of the output voltage is:
>
> TSTEP[1:0]: 00 Jump (no slope control)
> TSTEP[1:0]: 01 10mV/us
> TSTEP[1:0]: 10 5mV/us (default)
> TSTEP[1:0]: 11 2.5mV/us
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

