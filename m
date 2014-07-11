Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaGKQfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:35:50 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:33173 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbaGKQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:35:49 -0400
Message-ID: <53C01264.3020604@akamai.com>
Date: Fri, 11 Jul 2014 12:35:48 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove soon to be dead email address
References: <20140711161341.GF12054@laptop.lan> <CAMuHMdWj=aJsxZJPM=v-z8+=yTAopPWYe5T-+ovnnuEydFuGvA@mail.gmail.com> <20140711162153.GV20603@laptop.programming.kicks-ass.net>
In-Reply-To: <20140711162153.GV20603@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 12:21 PM, Peter Zijlstra wrote:
> On Fri, Jul 11, 2014 at 06:17:31PM +0200, Geert Uytterhoeven wrote:
>> On Fri, Jul 11, 2014 at 6:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> My Red Hat email address will soon cease to be; remove it from the
>>> tree in order to save the interweb some bounces.
>>
>>> --- a/include/linux/jump_label.h
>>> +++ b/include/linux/jump_label.h
>>> @@ -4,8 +4,8 @@
>>>  /*
>>>   * Jump label support
>>>   *
>>> - * Copyright (C) 2009-2012 Jason Baron <jbaron@redhat.com>
>>> - * Copyright (C) 2011-2012 Peter Zijlstra <pzijlstr@redhat.com>
>>> + * Copyright (C) 2009-2012 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
>>
>> Change not mentioned in comment (there are a few more of these).
>>
>>> + * Copyright (C) 2011-2012 Red Hat, Inc., Peter Zijlstra
> 
> Oh, right.. my bad. I should also have Cc'ed Jason I suppose.
> 
> The thing is, those were copyright RedHat (implicitly by the @redhat and
> my copyright assingment to employer at the time etc..) But if I remove
> the email address there is nothing that reflects that.
> 
> The same is true for Jason, but let me copy him.
> 

Thanks - feel free to remove my address there too. Otherwise, I can
follow-up with a separate posting.

Thanks,

-Jason
