Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDGADl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 20:03:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbaDGADk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 20:03:40 -0400
Message-ID: <5341EB52.1090704@oracle.com>
Date: Sun, 06 Apr 2014 20:03:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] autofs4: check dev ioctl size before allocating
References: <1394934021-16965-1-git-send-email-sasha.levin@oracle.com>		 <53401C11.7010601@oracle.com> <1396753403.24991.3.camel@perseus.fritz.box>	 <5340C5C7.9010203@oracle.com> <1396756437.24991.6.camel@perseus.fritz.box>
In-Reply-To: <1396756437.24991.6.camel@perseus.fritz.box>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2014 11:53 PM, Ian Kent wrote:
> On Sat, 2014-04-05 at 23:11 -0400, Sasha Levin wrote:
>> On 04/05/2014 11:03 PM, Ian Kent wrote:
>>> On Sat, 2014-04-05 at 11:06 -0400, Sasha Levin wrote:
>>>> Ping? Anyone wants to take this?
>>>
>>> Is this causing a problem for users?
>>> If it is I'll send it to Andrew straight away.
>>>
>>> I do have this on my queue but don't have any other patches to send so
>>> it's just sitting there.
>>>
>>> If it worries you I'll send it to Andrew now.
>>
>> It's not really a pressing issue since /dev/autofs is accessible only to
>> root. I also doubt that it causes problems for actual users.
>>
>> If there are no issues with the patch, I think it's best if you could
>> ack/sign off on it and if Andrew wants to take it now, he could. If he
>> doesn't, it could wait for whenever.
>>
>> I just don't want it getting lost somewhere and never making it upstream.
> 
> OK, but since I'm going to send it I looked at it a bit closer.
> Shouldn't the E2BIG be ENAMETOOLONG since it's a file path that's being
> passed?
> 
> I can change that and send it if you agree with the change.

Looks good to me, thanks!


Thanks,
Sasha

