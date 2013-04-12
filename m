Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab3DLUQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:16:23 -0400
Received: from smtp2.ispfabriek.nl ([188.142.0.19]:49009 "EHLO
	smtp2.ispfabriek.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3DLUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:16:19 -0400
Message-ID: <51686B74.2040204@xmsnet.nl>
Date: Fri, 12 Apr 2013 22:15:48 +0200
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121030 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] x86, vm86: fix VM86 syscalls: use SYSCALL_DEFINEx(...)
References: <514F6DF9.1070602@xmsnet.nl> <1364332526.8559.140661209554365.0203B0A4@webmail.messagingengine.com> <5152F321.7020604@xmsnet.nl> <1364412662.12858.140661209988437.506AD50B@webmail.messagingengine.com> <20130327194614.GA21522@ZenIV.linux.org.uk> <1364419085.8454.140661210031889.49ED573A@webmail.messagingengine.com>
In-Reply-To: <1364419085.8454.140661210031889.49ED573A@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 10:18 PM, Alexander van Heukelum wrote:
> On Wed, Mar 27, 2013, at 20:46, Al Viro wrote:
>> On Wed, Mar 27, 2013 at 08:31:02PM +0100, Alexander van Heukelum wrote:
>>> Hi Al,
>>>
>>> Hans de Bruin found a regression due to one of your changes. I asked him to test a fix and he reported back that it worked. (Thanks!) Can you see if you agree with the fix? Patch is attached due to webmail...
>>
>> Use SYSCALL_DEFINE{1,2} for vm86_old and vm86, please.
>
> Like this?
>
> Greetings,
>      Alexander
>

Is there any progress?

-- 
Hans
