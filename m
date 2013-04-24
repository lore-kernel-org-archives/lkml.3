Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3DXGKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:10:01 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19799 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3DXGKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:10:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Apr 2013 23:07:43 -0700
Message-ID: <5177762F.4010909@nvidia.com>
Date: Wed, 24 Apr 2013 11:35:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8973: Don't override control1 variable
 when set ramp delay bits
References: <1366733695.7020.1.camel@phoenix>
In-Reply-To: <1366733695.7020.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013 09:44 PM, Axel Lin wrote:
> Current code overrides control1 variable when setting ramp delay bits.
> Fix it by just setting ramp_delay bits.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Laxman Dewangan<ldewangan@nvidia.com>
