Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3LGIll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:41:41 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33886 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3LGIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:41:40 -0500
Message-ID: <52A2DF40.9070707@gmail.com>
Date: Sat, 07 Dec 2013 10:41:36 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>, pavel@ucw.cz,
        pali.rohar@gmail.com, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <52A16932.8020909@gmail.com> <20131206151030.GA22559@kroah.com>
In-Reply-To: <20131206151030.GA22559@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.12.2013 17:10, gregkh@linuxfoundation.org wrote:
> On Fri, Dec 06, 2013 at 08:05:38AM +0200, Ivajlo Dimitrov wrote:
>> Hi Greg,
>>
>> On 01.12.2013 19:07, Ivaylo DImitrov wrote:
>>> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>>>
>>> Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
>>> need to be exported. It can also be made way simpler by using sscanf.
>>>
>>> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
>>> ---
>>>    drivers/staging/tidspbridge/Makefile               |    2 +-
>>>    drivers/staging/tidspbridge/gen/uuidutil.c         |   85 --------------------
>>>    .../tidspbridge/include/dspbridge/uuidutil.h       |   18 ----
>>>    drivers/staging/tidspbridge/rmgr/dbdcd.c           |   42 +++++++++-
>>>    4 files changed, 39 insertions(+), 108 deletions(-)
>>>    delete mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
>>>
>> I guess the initial mail somehow didn't make it through your spam filter:
>> https://lkml.org/lkml/2013/12/1/70
> It did, but I thought that people asked for it to be changed in the
> thread afterwards, so I was expecting an updated version from you.
>
> Care to fix things up and resend it?
>
> thanks,
>
> greg k-h

Sure, the change I was asked for is trivial, but I didn't get the reason 
why it is needed. Neither there is a reply to my follow-up comment [0]. 
Sorry, I am pretty much new on LKML and could miss things that are 
supposed to be clear from the start, but my impression is that when 
someone says "it is better", he/she should explain why it is better or 
at least what is wrong with the patch he/she wants  to be changed.

However, I don't want to enter some arguing loop, so if you think I 
should change the code as per Joe's comment, just confirm it and I'll do it.

Thanks,
Ivo

[0] https://lkml.org/lkml/2013/12/1/113
