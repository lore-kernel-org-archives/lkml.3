Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3AYLGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:06:31 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:37887 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYLG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:06:26 -0500
MIME-Version: 1.0
In-Reply-To: <1359108275.6647.4.camel@x61.thuisdomein>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	<3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	<CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	<1359108275.6647.4.camel@x61.thuisdomein>
Date: Fri, 25 Jan 2013 12:06:25 +0100
Message-ID: <CACRpkdb0V=yasmJv1ygL7cq6G3uGf6+QAZ7GR5a3bb1-XJgiiA@mail.gmail.com>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Aaron Sierra <asierra@xes-inc.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:04 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Fri, 2013-01-25 at 10:47 +0100, Linus Walleij wrote:
>> On Thu, Jan 24, 2013 at 9:52 PM, Aaron Sierra <asierra@xes-inc.com> wrote:
>> > In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
>> > offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
>> > properly be enabled (and disabled) for these chipsets.
>> >
>> > Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
>> > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
>>
>> OK... Paul, can you test this on your setup?
>
> This seems to be the first time I'm added to this thread. I'm a bit lost
> here: why should I test this patch? This doesn't seem to be related to
> two older lpc_ich threads I was involved in (in November 2012). Not that
> I mind testing stuff, that's not the problem...

Basically I do git log and when I see this I think:

commit 0c418844dce21fa7000b51190f393c7d6a7ee12d
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Mon Nov 19 21:04:11 2012 +0100

    mfd: lpc_ich: One uninitialized cell is no error

"Hm, there is another guy who's actually using this hardware."

"If this patch breaks it he will probably be upset."

Yours,
Linus Walleij
