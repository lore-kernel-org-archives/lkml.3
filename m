Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaGaXOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 19:14:31 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58482 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaGaXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 19:14:30 -0400
MIME-Version: 1.0
In-Reply-To: <53DA3A2D.90403@compro.net>
References: <166070137.57941.1406779444750.JavaMail.root@mx2.compro.net>
	<53DA3A2D.90403@compro.net>
Date: Fri, 1 Aug 2014 08:14:29 +0900
Message-ID: <CAHb8M2BQk=vOJo-3KFukhOqWvC_Oa_77GDNEzC+vdWsDH6nxPA@mail.gmail.com>
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_cleanup_nodes()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Mark Hounschell <markh@compro.net>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

2014-07-31 21:44 GMT+09:00 Mark Hounschell <markh@compro.net>:
> On 07/31/2014 12:02 AM, Daeseok Youn wrote:
>>
>> When a configration file is parsed with dgap_parsefile(),
>> makes nodes for saving configrations for board.
>>
>> Making a node will allocate node memory and strings for saving
>> configrations with kstrdup().
>>
>> So these are freed when dgap is unloaded or failed to initialize.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>> V2: Do not need to free for NULLNODE.
>>
>> I have been too busy to solve this issue, sorry for late.
>>
>> Mark, Can you test this patch? I try to make simple module which is
>> testing dgap_parsefile() and dgap_cleanup_nodes().
>>
>
> I'll be happy to, but I can't do it until Monday. I'm not where the hardware
> is until then.
That's OK. :-)

Thanks.
Daeseok Youn.
>
> Regards
> Mark
>
