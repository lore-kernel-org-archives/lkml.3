Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3LTId0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:33:26 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1407 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3LTIdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:33:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Dec 2013 00:35:25 -0800
Message-ID: <52B400C7.7020002@nvidia.com>
Date: Fri, 20 Dec 2013 14:03:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: as3722: Don't set min_uV/uV_step/linear_min_sel
 for linear_ranges
References: <1387508269.10796.1.camel@phoenix>
In-Reply-To: <1387508269.10796.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 December 2013 08:27 AM, Axel Lin wrote:
> These settings are not used when using linear_ranges and it makes the code
> looks confusing. Thus remove them.

Looks fine.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>


