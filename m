Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3IWRrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:47:10 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:48737 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3IWRrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:47:08 -0400
Message-ID: <52407E82.9010807@gmail.com>
Date: Mon, 23 Sep 2013 19:46:42 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/26] ARM: dove: remove custom .init_time hook
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-12-git-send-email-sebastian.hesselbarth@gmail.com> <20130921122226.GB31180@lunn.ch> <523EE08C.60309@gmail.com> <20130923091036.GE4999@lunn.ch> <20130923133205.GF11119@titan.lakedaemon.net>
In-Reply-To: <20130923133205.GF11119@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 03:32 PM, Jason Cooper wrote:
> On Mon, Sep 23, 2013 at 11:10:36AM +0200, Andrew Lunn wrote:
>> On Sun, Sep 22, 2013 at 02:20:28PM +0200, Sebastian Hesselbarth wrote:
>>> On 09/21/2013 02:22 PM, Andrew Lunn wrote:
>>>> On Wed, Sep 18, 2013 at 07:53:44PM +0200, Sebastian Hesselbarth wrote:
>>>>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>>>>> remove custom .init_time hooks. While at it, also remove some obsolete
>>>>> includes.
>>>>>
>>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>>> ---
>>>>> Cc: Olof Johansson <olof@lixom.net>
>>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> ---
>>>>>   arch/arm/mach-dove/board-dt.c |   11 -----------
>>>>>   1 file changed, 11 deletions(-)
>>> [...]
>>>> Boot tested on cubox.
>>>>
>>>> Tested-by: Andrew Lunn <andrew@lunn.ch>
>>>
>>> Thanks Andrew!
>>>
>>> Aren't you giving any Acks for dove/kirkwood anymore?
>>
>> Hi Sebastian
>>
>> In my opinion, a Tested-by: has more weight than an Acked-by. I could
>> of given you an Acked-by in about 60 seconds, given the simplicity of
>> the patch. It took a lot more effort to get your tree, build it, fix
>> my binutils, since it was the first 3.12 tree i had tried and my
>> binutils was too old, and boot it.
>
> I would even go so far as to say that a Tested-by: from a maintainer
> carries an implied Ack.  ;-)
>
> And, just for the record,
>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

True, True, True. Lesson learned ;)

Thanks for both testing and ack'ing.

Sebastian

