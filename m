Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaAIMBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:01:10 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:51521 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaAIMBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:01:00 -0500
MIME-Version: 1.0
In-Reply-To: <1389265491.4041.6.camel@linaro1.home>
References: <1387815579-15677-1-git-send-email-taras.kondratiuk@linaro.org>
	<1387815579-15677-3-git-send-email-taras.kondratiuk@linaro.org>
	<1388764386.3430.10.camel@linaro1.home>
	<CAArO44ump6fid28qDGYK3=vMNLpgicMjYNO1hOdyU7D-Lkd3bQ@mail.gmail.com>
	<1389265491.4041.6.camel@linaro1.home>
Date: Thu, 9 Jan 2014 14:00:58 +0200
Message-ID: <CAArO44vRhQrxD25q=+SsgnRpd3UV0T=KZV_yh=uTEu0-PinMFg@mail.gmail.com>
Subject: Re: [PATCH 2/5] ARM: kprobes-test: use <asm/opcodes.h> for
 instruction accesses
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linaro Networking <linaro-networking@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.
I'll prepare a pull request.

On 9 January 2014 13:04, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> On Thu, 2014-01-09 at 12:54 +0200, Taras Kondratiuk wrote:
>> On 3 January 2014 17:53, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
>> > On Mon, 2013-12-23 at 18:19 +0200, Taras Kondratiuk wrote:
>> >> From: Ben Dooks <ben.dooks@codethink.co.uk>
>> >>
>> >> Ensure we read instructions in the correct endian-ness by using
>> >> the <asm/opcodes.h> helper to transform them as necessary.
>> >>
>> >> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>> >> [taras.kondratiuk@linaro.org: fix next_instruction() function]
>> >> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
>> >> ---
>> >
>> > Apart from the spurious line removal (see below) then:
>> >
>> > Acked-by: Jon Medhurst <tixy@linaro.org>
>> >
>> > and you can include an ACK for the other patches in this series too.
>> >
>> > Thanks.
>>
>> >> @@ -1593,7 +1594,6 @@ static int run_test_cases(void (*tests)(void), const union decode_item *table)
>> >>       return 0;
>> >>  }
>> >>
>> >> -
>> >
>> > I know the above blank line isn't needed but I believe the convention is
>> > to avoid doing unrelated white-space clean-ups in patches.
>>
>> Right, I will remove it.
>> Should this series go through Russell's patch tracking system or it
>> can be pulled
>> to some tree?
>
> I would assume as a pull request sent to Russell using the email alias
> he uses for these things: linux+pull@arm.linux.org.uk I'm sure he's
> shout up if I'm wrong...
>
> --
> Tixy
>



-- 
Regards,
Taras Kondratiuk
