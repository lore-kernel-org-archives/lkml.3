Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3B0XVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:21:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59003 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab3B0XVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:21:44 -0500
Message-ID: <512E94E2.50809@zytor.com>
Date: Wed, 27 Feb 2013 15:21:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECK
References: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org> <201302272032.21014.arnd@arndb.de> <512E6FA9.4060504@codeaurora.org> <512E8664.3070903@zytor.com> <512E8E48.8020007@codeaurora.org> <512E8ECF.1080307@zytor.com> <512E9480.7020306@codeaurora.org>
In-Reply-To: <512E9480.7020306@codeaurora.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 03:19 PM, Stephen Boyd wrote:
> On 02/27/13 14:55, H. Peter Anvin wrote:
>> On 02/27/2013 02:52 PM, Stephen Boyd wrote:
>>> On 02/27/13 14:19, H. Peter Anvin wrote:
>>>> On 02/27/2013 12:42 PM, Stephen Boyd wrote:
>>>>>> It's fine to do your patch as a first step though, which would not
>>>>>> change the behavior.
>>>>> A lot of arches seem to not want to enable it because false positives
>>>>> are everywhere. It really depends on how good the compiler is at doing
>>>>> constant propagation and dead code removal.
>>>>>
>>>> Although some of the cases I have seen being flagged as "false
>>>> positives" have been real bugs.
>>> There were so many false-positives on x86_64 that Andrew eventually
>>> dropped my patch to add support for this option to the copy_from_user()
>>> function there.
>>>
>> I would probably have taken it, especially if it came with more x86-64
>> to i386 unification.
>>
>> It's an option, though.
> 
> You acked the patch[1]. Will you pick it up?
> 
> [1] https://patchwork.kernel.org/patch/833192/
> 

I can, although I would prefer if it came with the uaccess/usercopy
unification.

	-hpa

