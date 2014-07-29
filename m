Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaG2WhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:37:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:39632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaG2WhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:37:03 -0400
Message-ID: <53D8220A.7000909@infradead.org>
Date: Tue, 29 Jul 2014 15:36:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Sangjung Woo <sangjung.woo@samsung.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, again4you@gmail.com,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: fix a typo in watchdog-api.txt
References: <1406621064-5466-1-git-send-email-sangjung.woo@samsung.com> <53D7D02D.6010508@infradead.org> <20140729205405.GA30849@spo001.leaseweb.com>
In-Reply-To: <20140729205405.GA30849@spo001.leaseweb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/14 13:54, Wim Van Sebroeck wrote:
> Hi Randy,
> 
>> On 07/29/14 01:04, Sangjung Woo wrote:
>>> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
>>> ---
>>>  Documentation/watchdog/watchdog-api.txt |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
>>> index eb7132e..53c49a4 100644
>>> --- a/Documentation/watchdog/watchdog-api.txt
>>> +++ b/Documentation/watchdog/watchdog-api.txt
>>> @@ -118,7 +118,7 @@ resets.
>>>  Note that the pretimeout is the number of seconds before the time
>>>  when the timeout will go off.  It is not the number of seconds until
>>>  the pretimeout.  So, for instance, if you set the timeout to 60 seconds
>>> -and the pretimeout to 10 seconds, the pretimout will go of in 50
>>> +and the pretimeout to 10 seconds, the pretimout will go off in 50
>>
>>                                          pretimeout
>>
>> Please correct that word also and then resend.  Also resend to:
>> trivial@kernel.org
>>
> 
> Can take this one through the linux-watchdog tree also.

OK, you can do that then.

Thanks.

-- 
~Randy
