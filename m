Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3LFHls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:41:48 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:37811 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3LFHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:41:46 -0500
Message-ID: <52A17FB4.9000301@gmail.com>
Date: Fri, 06 Dec 2013 09:41:40 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>, pavel@ucw.cz,
        pali.rohar@gmail.com
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <52A16932.8020909@gmail.com> <20131206073225.GD28413@mwanda>
In-Reply-To: <20131206073225.GD28413@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My other patch (the one that fixes the security issue) was already 
applied, albeit it was sent after this one, see 
https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/commit/?h=staging-linus&id=559c71fe5dc3bf2ecc55afb336145db7f0abf810 
, that is why I think there is some problem  with the mail itself.

Sure I will wait :)

regards,
Ivo

On 06.12.2013 09:32, Dan Carpenter wrote:
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
>>>   drivers/staging/tidspbridge/Makefile               |    2 +-
>>>   drivers/staging/tidspbridge/gen/uuidutil.c         |   85 --------------------
>>>   .../tidspbridge/include/dspbridge/uuidutil.h       |   18 ----
>>>   drivers/staging/tidspbridge/rmgr/dbdcd.c           |   42 +++++++++-
>>>   4 files changed, 39 insertions(+), 108 deletions(-)
>>>   delete mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
>>>
>> I guess the initial mail somehow didn't make it through your spam filter:
>> https://lkml.org/lkml/2013/12/1/70
>>
> It's too early to start resending.  Wait for another week at least.
>
> regards,
> dan carpenter
>

