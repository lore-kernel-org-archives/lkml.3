Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaFZIZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:25:42 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33090 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaFZIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:25:37 -0400
Message-ID: <53ABD8FB.9000700@suse.cz>
Date: Thu, 26 Jun 2014 10:25:31 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>	<1403694435-3180-5-git-send-email-jslaby@suse.cz> <20140625134212.4fb38e14@alan.etchedpixels.co.uk>
In-Reply-To: <20140625134212.4fb38e14@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 02:42 PM, One Thousand Gnomes wrote:
> On Wed, 25 Jun 2014 13:06:59 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> This is based on Udo's text which was augmented in this patch.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Udo Seidel <udoseidel@gmx.de>
>> Cc: Vojtech Pavlik <vojtech@suse.cz>
>> ---
>>  kernel/Kconfig.kgraft | 3 +++
>>  samples/Kconfig       | 4 ++++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/kernel/Kconfig.kgraft b/kernel/Kconfig.kgraft
>> index f38d82c06580..bead93646071 100644
>> --- a/kernel/Kconfig.kgraft
>> +++ b/kernel/Kconfig.kgraft
>> @@ -5,3 +5,6 @@ config KGRAFT
>>  	bool "kGraft infrastructure"
>>  	depends on DYNAMIC_FTRACE_WITH_REGS
>>  	depends on HAVE_KGRAFT
>> +	help
>> +	  Select this to enable kGraft online kernel patching. The
>> +	  runtime price is zero, so it is safe to say Y here.
>> diff --git a/samples/Kconfig b/samples/Kconfi
> 
> The runtime impact is that you've just introduced a virus and trojan
> writers delight into your kernel. There's a balance between convenience
> and security but given most users will never use kgraft this advice seems
> incorrect.

This now writes:
+       help
+         Select this to enable kGraft online kernel patching. The
+         runtime price is nearly zero, so it is safe to say Y here
+         provided you are aware of all the consequences (e.g. in
+         security).

Is it OK with you?

thanks,
-- 
js
suse labs
