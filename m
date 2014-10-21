Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbaJUSAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:00:51 -0400
Received: from mx2.comprocs.com ([12.186.155.30]:63429 "HELO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933399AbaJUSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:00:49 -0400
X-BYPSHEADER: 3526281
X-SMScore: -200
Message-ID: <54469F4C.9070703@compro.net>
Date: Tue, 21 Oct 2014 14:00:44 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>
CC: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: dgap: re-arrange functions for removing forward
 declarations.
References: <20141013023425.GA15452@devel> <20141013032544.GA26646@kroah.com> <CAHb8M2A5e2akETQoWS6WfNJjUqhyu4ptfTMs9HLYgbw8XRR-Ww@mail.gmail.com> <1413212198.1287.9.camel@joe-AO725> <1441864556.1190074.1413252337243.JavaMail.root@mx2.compro.net> <1480715134.1194532.1413288717130.JavaMail.root@mx2.compro.net>
In-Reply-To: <1480715134.1194532.1413288717130.JavaMail.root@mx2.compro.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 08:01 AM, Mark Hounschell wrote:
> On 10/13/2014 10:04 PM, Greg KH wrote:
>> On Mon, Oct 13, 2014 at 07:56:38AM -0700, Joe Perches wrote:
>>> On Mon, 2014-10-13 at 17:01 +0900, DaeSeok Youn wrote:
>>>> Hi,
>>>>
>>>> 2014-10-13 12:25 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
>>>>> On Mon, Oct 13, 2014 at 11:34:25AM +0900, Daeseok Youn wrote:
>>>>>> Re-arrange the functions for removing forward declarations.
>>>>>>
>>>>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>>>>> ---
>>>>>> This patch has too many changes for re-arranging the functions.
>>>>>> So I wonder that I should break this up into smaller patches.
>>>>>
>>>>> Are the .o files identical before and after this patch?  If so, it's
>>>>> fine.
>>>> Ok. I will check for that.
>>>
>>> The .o files shouldn't be identical after function reordering.
>>
>> Hm, they might be the same size, but I can see how on some
>> architectures (like ppc) how that would not be the case, you are right.
>>
>> Isn't there an "objdiff" program or something like that which might help
>> in validating that nothing "changed" in the source for type of patch
>> that just moves functions around in a file.
>>
>> thanks,
>>
>
> Greg,
>
> Would just testing the thing be of any help?
>
> Regards
> Mark

I don't know what is going on with this patch, but for what it's worth, 
I have applied this patch and my testing still shows everything OK.

Tested-by: Mark Hounschell <markh@compro.net>

Regards
Mark

