Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3ASW7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 17:59:18 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35318 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3ASW7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 17:59:16 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <50FB249D.4050906@ilyx.ru>
References: <CA+icZUWKCbaL=oAwBk0vcPtLrGmvsqPdpXdYAqPZVKzA9Y_iDw@mail.gmail.com>
	<50FB2197.7010306@ilyx.ru>
	<CA+icZUU-4WXXMTCjRWP6H7+JhytBSWuA55-JFyu3yowcT6Q4xw@mail.gmail.com>
	<50FB249D.4050906@ilyx.ru>
Date: Sat, 19 Jan 2013 23:59:15 +0100
Message-ID: <CA+icZUVqR9FCk4PcoXJJwa+zEkU3rf6cDwvYKkocfJpVhGo7xQ@mail.gmail.com>
Subject: Re: [next-20130118] Analyzing a call-trace reproducible with
 pm_test/freezer [ X86|RCU|TTY|EXT4FS|JBD2|PM related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        linux-serial@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, Jan Kara <jack@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 11:56 PM, Ilya Zykov <ilya@ilyx.ru> wrote:
> On 20.01.2013 2:51, Sedat Dilek wrote:
>> On Sat, Jan 19, 2013 at 11:43 PM, Ilya Zykov <ilya@ilyx.ru> wrote:
>>> Hello!
>>> I don't expert, but
>>> maybe it can help.
>>>
>>> I test with:
>>>   while echo mem > /sys/power/state; do sleep 2; done
>>> in one X-terminal, in other I trying playing with keyboard.
>>> (Without playing all right I use ext3.)
>>
>> Can you test with the patches listed in [1] (including two TTY patches
>> from you!)?
>> My base is Linux-Next (next-20130118).
>> FYI: My Ubuntu/precise is EXT4FS-formatted.
>>
> Ok.
> but not now I have 3.00 night.
> I already use this in my 3.8.0-rc3-next-20130118-pm+.
>  tty: Correct tty buffer flush.
>

The TTY patches are not enough, you need in addition the JBD2 fix [1].

- Sedat -

[1] http://patchwork.ozlabs.org/patch/207237/

>
