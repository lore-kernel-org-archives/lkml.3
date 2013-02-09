Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab3BIE5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 23:57:41 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47364 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760649Ab3BIE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 23:57:40 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302081331000.6300@xanadu.home>
References: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com>
	<CACRpkdbwoExxKbbvBKpt_Wh9KsgCXQW566N-0BaeL3oGY8pvLg@mail.gmail.com>
	<20130206163355.GH17833@n2100.arm.linux.org.uk>
	<20130208065125.GA20440@lge.com>
	<20130208150317.GT17833@n2100.arm.linux.org.uk>
	<alpine.LFD.2.02.1302081331000.6300@xanadu.home>
Date: Sat, 9 Feb 2013 13:57:39 +0900
Message-ID: <CAAmzW4OG9GhPViqSyw9sN4wtUAU0YPjcPz-kT3MQhqZwnPdORQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] ARM: sched: correct update_sched_clock()
From: JoonSoo Kim <js1304@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/9 Nicolas Pitre <nicolas.pitre@linaro.org>:
> On Fri, 8 Feb 2013, Russell King - ARM Linux wrote:
>
>> On Fri, Feb 08, 2013 at 03:51:25PM +0900, Joonsoo Kim wrote:
>> > I try to put it into patch tracker, but I fail to put it.
>> > I use following command.
>> >
>> > git send-email --to patches@arm.linux.org.uk 0001-ARM-sched-correct~~~~~
>> >
>> > Am I wrong?
>> > Could you teach me how to put patch into your patch tracker?
>> > I already read "help" on your website, but I can't find any stuff for
>> > "git send-email".
>>
>> I've never used git to send email, so I'm afraid I can't help with that.
>> Maybe someone with more experience with sending email from git can
>> comment?
>
> The commit text for the patch needs to contain the following 2 lines at
> the very bottom in order to match the patch system's expectations:
>
> PATCH FOLLOWS
> KernelVersion: v3.8
>
> The KernelVersion value needs to be adjusted of course.
>
> Note: I never tried it myself but it ought to work.

Yes!!!! It works!
Thanks!!!

> Nicolas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
