Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaGBUHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:07:31 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48005 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbaGBUH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <53B46608.8030408@zytor.com>
References: <20140701000913.5ea51f77@gandalf.local.home> <CALCETrW8MYApbyVZ3zxhX3StqVZVBux1xoF8y+gNBAaUP7y6TQ@mail.gmail.com>
 <53B46608.8030408@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 2 Jul 2014 13:07:08 -0700
Message-ID: <CALCETrUDKUvB9TdPReBg+yv+Ss867G7mu3=r1YRAGW9tutbN8w@mail.gmail.com>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max = 13)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 1:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/02/2014 01:00 PM, Andy Lutomirski wrote:
>>
>> I managed to munge the binutils sources enough to build binutils 2.21.
>> This seems to be a binutils bug: ld generates an empty .rela.dyn.
>> Fortunately, it's not generating a DT_RELA dynamic entry.
>>
>
> Not sure if that is a bug.  Unnecessary, yes, but it ought to be legal.

Right.  But I don't really want to chase down some oddity like this
every week until 3.16 comes out.

--Andy

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
