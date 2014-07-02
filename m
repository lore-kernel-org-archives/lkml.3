Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbaGBUTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:19:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53305 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbaGBUTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:19:05 -0400
Message-ID: <53B4692C.7010107@zytor.com>
Date: Wed, 02 Jul 2014 13:18:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max =
 13)
References: <20140701000913.5ea51f77@gandalf.local.home> <CALCETrW8MYApbyVZ3zxhX3StqVZVBux1xoF8y+gNBAaUP7y6TQ@mail.gmail.com> <53B46608.8030408@zytor.com> <CALCETrUDKUvB9TdPReBg+yv+Ss867G7mu3=r1YRAGW9tutbN8w@mail.gmail.com>
In-Reply-To: <CALCETrUDKUvB9TdPReBg+yv+Ss867G7mu3=r1YRAGW9tutbN8w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 01:07 PM, Andy Lutomirski wrote:
> On Wed, Jul 2, 2014 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/02/2014 01:00 PM, Andy Lutomirski wrote:
>>>
>>> I managed to munge the binutils sources enough to build binutils 2.21.
>>> This seems to be a binutils bug: ld generates an empty .rela.dyn.
>>> Fortunately, it's not generating a DT_RELA dynamic entry.
>>>
>>
>> Not sure if that is a bug.  Unnecessary, yes, but it ought to be legal.
> 
> Right.  But I don't really want to chase down some oddity like this
> every week until 3.16 comes out.
> 
> --Andy
> 

Right.

	-hpa


