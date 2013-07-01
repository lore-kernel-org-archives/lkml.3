Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3GAGHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:07:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34375 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3GAGHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:07:20 -0400
Message-ID: <51D11C8D.2010400@ti.com>
Date: Mon, 1 Jul 2013 11:37:09 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Keerthy <a0393675@ti.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
References: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au>
In-Reply-To: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Keerthy

On Monday 01 July 2013 09:48 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the regulator tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/regulator/palmas-regulator.c: In function 'palmas_regulators_probe':
> drivers/regulator/palmas-regulator.c:850:8: error: 'PALMAS_REG_SMPS10' undeclared (first use in this function)
>     case PALMAS_REG_SMPS10:
>          ^
>
> Caused by commit 07a02e0b1a4f ("regulator: palmas: model SMPS10 as two
> regulators").  Clearly not build tested at all :-(  Grep is your
> friend ...

commit 1ffb0b (mfd: palmas: Add SMPS10_BOOST feature) had used PALMAS_REG_SMPS10
and I dint have that patch in my tree. Sorry, my bad.
Keerthy will send a fix for it.

Thanks
Kishon
