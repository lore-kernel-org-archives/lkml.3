Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaCBQVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 11:21:49 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:43723 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaCBQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 11:21:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAAsK9AEWRD+n=bjAsJ-oRJsc+UQJ_LC+F9Psc+cCcK2rLzYsPw@mail.gmail.com>
References: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com>
 <53134C4D.2090406@linux.com> <1393774826.13719.31.camel@joe-AO722> <CAAsK9AEWRD+n=bjAsJ-oRJsc+UQJ_LC+F9Psc+cCcK2rLzYsPw@mail.gmail.com>
From: Yogesh Chaudhari <mr.yogesh@gmail.com>
Date: Sun, 2 Mar 2014 21:51:07 +0530
Message-ID: <CAAOfnZpW7GLb2dUfGGe7ET7QXQuNvVsjGcz_RkNy00omoM_8sw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed warning
 message in case printk is used in any patch
To: Levente Kurusa <levex@linux.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Robo Bot <apw@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 March 2014 21:19, Levente Kurusa <levex@linux.com> wrote:
> Hi,
>
> 2014-03-02 16:40 GMT+01:00 Joe Perches <joe@perches.com>:
>> On Sun, 2014-03-02 at 16:20 +0100, Levente Kurusa wrote:
>>> IMHO, this message is too big. The one we already have is nice and clean.
>>> I would simply do: s/netdev/[subsystem]/ or something among the lines.
>>
>> maybe:
>>
>> "Prefer [subsystem eg: netdev]_$level2 then dev_$level2 then pr_$level to printk(KERN_$orig ...\n"
>
> Excellent, that looks the best and combines the best of two worlds.
>
>>
>> or reference the stackoverflow link
>>
>
> And what if that disappears? Might as well write this to
> Documentation/CodingStyle
> as I have previously mentioned. Yogesh, you want to do this or should I?

I will send in a new patch with both the script file and the
documentation modifications.

>
> --
> Regards,
> Levente Kurusa


Regards
Yogesh

-- 
DREAM IT, CODE IT
