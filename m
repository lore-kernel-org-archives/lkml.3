Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3F3Qle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:41:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15355 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3Qlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:41:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 30 Jun 2013 09:41:19 -0700
Message-ID: <51D06155.3030108@nvidia.com>
Date: Sun, 30 Jun 2013 22:18:21 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] palmas: Simplify regulator_desc setting for SMPS10_[OUT1|OUT2]
References: <1372476470.8773.1.camel@phoenix>
In-Reply-To: <1372476470.8773.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 June 2013 08:57 AM, Axel Lin wrote:
> The regulator_desc setting for SMPS10-OUT1 and SMPS10-OUT2 are very similar,
> only enable_mask is different.
> Make the switch case fall through to simplify the code.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>
The change looks good,
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

