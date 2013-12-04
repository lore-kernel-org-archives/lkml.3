Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3LDIj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:39:27 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42868 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3LDIjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:39:25 -0500
Message-ID: <529EEAC1.3010203@gmail.com>
Date: Wed, 04 Dec 2013 16:41:37 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>,
        rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
References: <528AEFB7.4060301@gmail.com>   <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>   <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>   <52957ADA.2080704@gmail.com>   (sfid-20131127_055211_558798_A7DF5684) <1385739487.8656.1.camel@jlt4.sipsolutions.net>   <5299D306.7070701@gmail.com>   (sfid-20131130_125901_519610_EDA4068E) <1385816013.4327.1.camel@jlt4.sipsolutions.net>   <5299ED38.4090509@gmail.com> <5299EFDD.6060405@gmail.com>   (sfid-20131130_150205_984535_068F14A9) <1385842134.6108.4.camel@jlt4.sipsolutions.net>   <1385843940.2664.4.camel@joe-AO722>   <1385890523.4171.1.camel@jlt4.sipsolutions.net>   <1385937499.2664.21.camel@joe-AO722>  <1385995738.20277.4.camel@jlt4.sipsolutions.net>  <529E8F90.1020205@gmail.com> (sfid-20131204_031032_173575_B927B340) <1386144281.4284.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1386144281.4284.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 04:04 PM, Johannes Berg wrote:
> On Wed, 2013-12-04 at 10:12 +0800, Chen Gang wrote:
> 
>> It is really not urgent, and for keeping quality, it is necessary to
>> spend suitable time resource (e.g 1 hour or more) to  make, review and
>> test this kind of patch carefully by oneself.
>>
>> So could you please help improve it when you have suitable related time
>> resources?
> 
> No. Who are you to suggest what I need to work on?
> 
> johannes
> 

I am one of volunteers for Open Source, and I don't care about who I am.

Since this thread is started by me, I have duty to try my best to let it
finish (but may fail).

According to our original discussion, it seems we agree that I am not
the suitable member to finish it, so I suggest you or another members to
try.


Thanks.
-- 
Chen Gang
