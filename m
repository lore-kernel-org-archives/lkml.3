Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaHDMkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:40:23 -0400
Received: from mx2.comprocs.com ([12.186.155.30]:55153 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751249AbaHDMkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:40:22 -0400
X-BYPSHEADER: 2868287
X-SMScore: -200
Message-ID: <53DF7F34.5030201@compro.net>
Date: Mon, 04 Aug 2014 08:40:20 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: DaeSeok Youn <daeseok.youn@gmail.com>
CC: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH V2] staging: dgap: introduce dgap_cleanup_nodes()
References: <166070137.57941.1406779444750.JavaMail.root@mx2.compro.net>	<53DA3A2D.90403@compro.net> <1598413764.80217.1406848485858.JavaMail.root@mx2.compro.net>
In-Reply-To: <1598413764.80217.1406848485858.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 07:14 PM, DaeSeok Youn wrote:
> Hi, Mark
>
> 2014-07-31 21:44 GMT+09:00 Mark Hounschell <markh@compro.net>:
>> On 07/31/2014 12:02 AM, Daeseok Youn wrote:
>>>
>>> When a configration file is parsed with dgap_parsefile(),
>>> makes nodes for saving configrations for board.
>>>
>>> Making a node will allocate node memory and strings for saving
>>> configrations with kstrdup().
>>>
>>> So these are freed when dgap is unloaded or failed to initialize.
>>>
>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>> ---
>>> V2: Do not need to free for NULLNODE.
>>>
>>> I have been too busy to solve this issue, sorry for late.
>>>
>>> Mark, Can you test this patch? I try to make simple module which is
>>> testing dgap_parsefile() and dgap_cleanup_nodes().
>>>
>>
>> I'll be happy to, but I can't do it until Monday. I'm not where the hardware
>> is until then.
> That's OK. :-)
>

After applying this patch I am still able to load and unload the driver 
at will, and it still works for me.

Regards
Mark

