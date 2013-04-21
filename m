Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab3DUJFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:05:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12134 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3DUJFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:05:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 21 Apr 2013 02:05:52 -0700
Message-ID: <5173AAF4.9010205@nvidia.com>
Date: Sun, 21 Apr 2013 14:31:40 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: palmas: Add missing ctrl_addr setting for
 SMPS10
References: <1366374825.4345.1.camel@phoenix>
In-Reply-To: <1366374825.4345.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013 06:03 PM, Axel Lin wrote:
> The ctrl_addr setting for SMPS10 is missed, thus palmas_smps_init() read/write
> wrong register for SMPS10 in current code. Fix it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Acked-by: Laxman Dewangan<ldewangan@nvidia.com>

