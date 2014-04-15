Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaDORST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:18:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45834 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDORSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:18:17 -0400
Message-ID: <534D69D0.207@ti.com>
Date: Tue, 15 Apr 2014 12:18:08 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joachim Eastwood <manabian@gmail.com>
CC: Joel Fernandes <joelf@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCH V2] crypto: omap-des - handle error of pm_runtime_get_sync
References: <534D61DF.9090203@ti.com>	<1397581111-21148-1-git-send-email-nm@ti.com> <CAGhQ9Vxv682wD982sNDtc5-Zk4y7H2eULWcm8CJ2SiG=s7V=Pg@mail.gmail.com>
In-Reply-To: <CAGhQ9Vxv682wD982sNDtc5-Zk4y7H2eULWcm8CJ2SiG=s7V=Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 12:06 PM, Joachim Eastwood wrote:
> On 15 April 2014 18:58, Nishanth Menon <nm@ti.com> wrote:
>> pm_runtime_get_sync may not always succeed depending on SoC involved.
>> So handle the error appropriately ensuring usage_count is accurate in
>> case of failure.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>> V2:
>>         - review fixes, print function names in error log as well.
>>
>> V1: https://patchwork.kernel.org/patch/3993861/
>>  drivers/crypto/omap-des.c |   26 +++++++++++++++++++++++---
>>  1 file changed, 23 insertions(+), 3 deletions(-)
>>
> 
> Fixes the runtime warning from omap_l3_noc when omap-des is built-in
> on my VAR-SOM-OM44 (OMAP4460) board.
> 
> Tested-by: Joachim Eastwood <manabian@gmail.com>

Thanks Joachim. Looks like in my hurry, I missed proper
acknowledgement of your report. adding the following for patchworks to
pickup.

Reported-by: Joachim Eastwood <manabian@gmail.com>


-- 
Regards,
Nishanth Menon
