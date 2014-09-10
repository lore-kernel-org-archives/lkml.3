Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaIJCuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 22:50:51 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:55270 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751432AbaIJCuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 22:50:50 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <5a72e60780bb64abc126c240f8aa3cd6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <540FB86C.6010900@rock-chips.com>
Date: Wed, 10 Sep 2014 10:33:16 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the regulator tree
References: <20140908183350.5a4e357c@canb.auug.org.au> <20140909223952.GL2601@sirena.org.uk>
In-Reply-To: <20140909223952.GL2601@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/10/2014 06:39 AM, Mark Brown wrote:
> On Mon, Sep 08, 2014 at 06:33:50PM +1000, Stephen Rothwell wrote:
>
>> drivers/regulator/rk808-regulator.c:312:18: warning: 'struct rk808_board' declared inside parameter list
>>             struct rk808_board *pdata)
> Chris, as previously requested please send me any changes needed to
> update for the changes in the MFD driver.
Yes, I have modified the rk808.h, so rk808-regulator.c lacks some 
structure now.
Please help me review the patch "[PATCH v10 3/3] regulator: RK808: 
Remove pdata from the regulator"
It contains the corresponding changes.
