Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3GAIr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:47:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38876 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3GAIrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:47:25 -0400
Message-ID: <51D14212.50703@ti.com>
Date: Mon, 1 Jul 2013 14:17:14 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Keerthy <a0393675@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
References: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au> <51D11C8D.2010400@ti.com> <20130701084339.GS27646@sirena.org.uk>
In-Reply-To: <20130701084339.GS27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 July 2013 02:13 PM, Mark Brown wrote:
> On Mon, Jul 01, 2013 at 11:37:09AM +0530, Kishon Vijay Abraham I wrote:
>
>> commit 1ffb0b (mfd: palmas: Add SMPS10_BOOST feature) had used PALMAS_REG_SMPS10
>> and I dint have that patch in my tree. Sorry, my bad.
>> Keerthy will send a fix for it.
>
> Resubmit the patch, I've dropped it.

Ok. I'll resend the patch.

Thanks
Kishon
