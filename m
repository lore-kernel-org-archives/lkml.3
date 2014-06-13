Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaFMDgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 23:36:55 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:58778 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaFMDgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 23:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140612.110519.583755215428272991.davem@davemloft.net>
References: <1402564248-20606-1-git-send-email-varkab@cdac.in>
	<20140612.110324.932062947770396872.davem@davemloft.net>
	<20140612.110519.583755215428272991.davem@davemloft.net>
Date: Fri, 13 Jun 2014 09:06:52 +0530
Message-ID: <CAEUmHyZFvaMRbxDrnE=bbnA=FGn2jAFUgzg_oZVswHHzLGR1iw@mail.gmail.com>
Subject: Re: [PATCH net-next] mrf24j40: separate h/w init and add checkings
From: Varka Bhadram <varkabhadram@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org,
        Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Sorry for the noise. i will send the fixed patch.

Thanks.

-Varka Bhadram

On Thu, Jun 12, 2014 at 11:35 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 12 Jun 2014 11:03:24 -0700 (PDT)
>
>> From: Varka Bhadram <varkabhadram@gmail.com>
>> Date: Thu, 12 Jun 2014 14:40:48 +0530
>>
>>> separate the mrf24j40 hardware initialisation from probe()
>>> and adds the sanity checkings.
>>>
>>> These checkings are required if somebody hasn't a right spi configuration
>>> the probe function should fail. So we have to return from there.
>>>
>>> Signed-off-by: Varka Bhadram <varkab@cdac.in>
>>
>> Applied, thanks.
>
> Reverted, did you even compile test this change?
>
> drivers/net/ieee802154/mrf24j40.c: In function ‘mrf24j40_probe’:
> drivers/net/ieee802154/mrf24j40.c:741:10: error: ‘err_hw_init’ undeclared (first use in this function)
> drivers/net/ieee802154/mrf24j40.c:741:10: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ieee802154/mrf24j40.c:759:1: warning: label ‘err_hw_init’ defined but not used [-Wunused-label]
> drivers/net/ieee802154/mrf24j40.c:702:5: warning: unused variable ‘val’ [-Wunused-variable]
> make[1]: *** [drivers/net/ieee802154/mrf24j40.o] Error 1
> make: *** [drivers/net/ieee802154/mrf24j40.o] Error 2
