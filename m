Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaHDXdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:33:18 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:54174 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaHDXdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <53DF7F34.5030201@compro.net>
References: <166070137.57941.1406779444750.JavaMail.root@mx2.compro.net>
	<53DA3A2D.90403@compro.net>
	<1598413764.80217.1406848485858.JavaMail.root@mx2.compro.net>
	<53DF7F34.5030201@compro.net>
Date: Tue, 5 Aug 2014 08:33:16 +0900
Message-ID: <CAHb8M2DkfnkrsjLciSvS=_0GM4wn1dC33ExUWS7nYG=mnNH+Xg@mail.gmail.com>
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_cleanup_nodes()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Mark Hounschell <markh@compro.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark and Greg.

Thanks for testing. :-)

Greg, is this patch possible to merge to your staging tree?
Please check for me.
patch : https://lkml.org/lkml/2014/7/31/2

Thanks.

regards,
Daeseok Youn.

2014-08-04 21:40 GMT+09:00 Mark Hounschell <markh@compro.net>:
> On 07/31/2014 07:14 PM, DaeSeok Youn wrote:
>>
>> Hi, Mark
>>
>> 2014-07-31 21:44 GMT+09:00 Mark Hounschell <markh@compro.net>:
>>>
>>> On 07/31/2014 12:02 AM, Daeseok Youn wrote:
>>>
>>>>
>>>> When a configration file is parsed with dgap_parsefile(),
>>>> makes nodes for saving configrations for board.
>>>>
>>>> Making a node will allocate node memory and strings for saving
>>>> configrations with kstrdup().
>>>>
>>>> So these are freed when dgap is unloaded or failed to initialize.
>>>>
>>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>>> ---
>>>> V2: Do not need to free for NULLNODE.
>>>>
>>>> I have been too busy to solve this issue, sorry for late.
>>>>
>>>> Mark, Can you test this patch? I try to make simple module which is
>>>> testing dgap_parsefile() and dgap_cleanup_nodes().
>>>>
>>>
>>> I'll be happy to, but I can't do it until Monday. I'm not where the
>>> hardware
>>> is until then.
>>
>> That's OK. :-)
>>
>
> After applying this patch I am still able to load and unload the driver at
> will, and it still works for me.
>
> Regards
> Mark
>
