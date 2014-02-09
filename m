Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaBIUEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:04:38 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752266AbaBIUEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:04:37 -0500
Message-ID: <52F7DF51.8000507@nod.at>
Date: Sun, 09 Feb 2014 21:04:33 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
References: <1391971686-9517-1-git-send-email-richard@nod.at>	 <1391971686-9517-25-git-send-email-richard@nod.at> <1391974709.25855.3.camel@x220>
In-Reply-To: <1391974709.25855.3.camel@x220>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2014 20:38, schrieb Paul Bolle:
> On Sun, 2014-02-09 at 19:48 +0100, Richard Weinberger wrote:
>> The symbol is an orphan, get rid of it.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  arch/mn10300/Kconfig.debug | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
>> index 94efb3e..af18047 100644
>> --- a/arch/mn10300/Kconfig.debug
>> +++ b/arch/mn10300/Kconfig.debug
>> @@ -32,7 +32,7 @@ config KPROBES
>>  
>>  config GDBSTUB
>>  	bool "Remote GDB kernel debugging"
>> -	depends on DEBUG_KERNEL && DEPRECATED
>> +	depends on DEBUG_KERNEL
> 
> But now you've enabled a lot of stuff that, as far as I can tell, could
> not have been built since v2.6.39.

This is by design. If the code does not build/work it needs to be fixed or removed.

Thanks,
//richard
