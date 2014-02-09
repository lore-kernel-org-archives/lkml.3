Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaBIVfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:35:08 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59376 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaBIVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:35:06 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F7F486.7040003@roeck-us.net>
Date: Sun, 09 Feb 2014 13:35:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Paul Bolle <pebolle@tiscali.nl>
CC: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
References: <1391971686-9517-1-git-send-email-richard@nod.at>	 <1391971686-9517-25-git-send-email-richard@nod.at> <1391974709.25855.3.camel@x220> <52F7DF51.8000507@nod.at>
In-Reply-To: <52F7DF51.8000507@nod.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 12:04 PM, Richard Weinberger wrote:
> Am 09.02.2014 20:38, schrieb Paul Bolle:
>> On Sun, 2014-02-09 at 19:48 +0100, Richard Weinberger wrote:
>>> The symbol is an orphan, get rid of it.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>   arch/mn10300/Kconfig.debug | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
>>> index 94efb3e..af18047 100644
>>> --- a/arch/mn10300/Kconfig.debug
>>> +++ b/arch/mn10300/Kconfig.debug
>>> @@ -32,7 +32,7 @@ config KPROBES
>>>
>>>   config GDBSTUB
>>>   	bool "Remote GDB kernel debugging"
>>> -	depends on DEBUG_KERNEL && DEPRECATED
>>> +	depends on DEBUG_KERNEL
>>
>> But now you've enabled a lot of stuff that, as far as I can tell, could
>> not have been built since v2.6.39.
>
> This is by design. If the code does not build/work it needs to be fixed or removed.
>

I could understand if you would replace DEPRECATED with BROKEN,
but causing a potentially large number of broken builds and
then leave it to others to clean up the resulting mess doesn't
make any sense to me and should, in my opinion, be rejected.

Guenter



