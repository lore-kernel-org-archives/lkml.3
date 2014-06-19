Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbaFSCzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:55:33 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:40562 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbaFSCzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <7hzjha5ew2.fsf@paris.lan>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
	<1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
	<7hionz9i5e.fsf@paris.lan>
	<CAJe_ZhcuOa39Db_tE4JupY74aze02=v1FWzduFD0sO15nMrKvw@mail.gmail.com>
	<7hzjha5ew2.fsf@paris.lan>
Date: Thu, 19 Jun 2014 08:25:30 +0530
Message-ID: <CAJe_ZhfTCw3OHNeSTW71bc6U2g_d=5hYknu+dwhBkuZvPg=D6w@mail.gmail.com>
Subject: Re: [PATCHv7 2/5] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Patch Tracking <patches@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, ijc+devicetree@hellion.org.uk,
        Arnd Bergmann <arnd@arndb.de>, Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2014 22:33, Kevin Hilman <khilman@linaro.org> wrote:
> Jassi Brar <jaswinder.singh@linaro.org> writes:
>
>> On 18 June 2014 05:57, Kevin Hilman <khilman@linaro.org> wrote:
>>> Jassi Brar <jaswinder.singh@linaro.org> writes:
>>>
>>>> Introduce common framework for client/protocol drivers and
>>>> controller drivers of Inter-Processor-Communication (IPC).
>>>>
>>>> Client driver developers should have a look at
>>>>  include/linux/mailbox_client.h to understand the part of
>>>> the API exposed to client drivers.
>>>> Similarly controller driver developers should have a look
>>>> at include/linux/mailbox_controller.h
>>>>
>>>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>>>
>>> This series is shaping up nicely.  The one thing I think it would
>>> benefit from, being a new common framework is something under
>>> Documentation giving a brief overview, but more importantly some
>>> example code snippets of a mailbox client using the API, and maybe an
>>> example usage of the controller API as well.
>>>
>>> Not only will that guide developers who want to use/implement this API
>>> on their platforms, it will also aid reviewers.
>>>
>> I have been trying to get it upstream for quite some time now because
>> my platform depends upon it. I am planning to submit my platform
>> support which should have a client and controller side of the mailbox
>> API.
>
> Having a reference implementation is great, but I don't think that
> removes the need for a bit of Documentation when introducing a new
> framework.
>
> It's pretty common to see new IPC mechanisms posted and being able to
> point somone to this framework and something under Documentation/* would
> be a great help in getting more users of the framework.
>
Of course. I didn't mean I won't add Documentation.

>> Though I am told the API (until v4 at least) supported usecases for 5
>> different platforms.
>
> That's great.
>
> I sure would like to see some more Reviewed-by tags from those folks to
> confirm that those starting to use it think it's on the right track.
>
The upstreaming attempts have been going on for months now, and via
non-public interactions with developers I understand it last worked
before the revision mandating DT support and ipc->mailbox symbol
renaming. So basic working should still remain the same.
   Suman(TI), Loic(ST), Girish(Samsung), Ashwin (PCC+ACPI).... guys,
any word for v7?

LFTan(Intel) and Craig(Broadcom) seem unresponsive now, unfortunately :(

Thanks
-Jassi
