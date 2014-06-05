Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaFELjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:39:24 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:33404 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaFELjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140605111205.GD32082@beef>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
	<1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
	<7978295.UBGxYvcnvH@wuerfel>
	<CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
	<20140529154348.GH32082@beef>
	<CABb+yY2PiGpqy2uevCFexAKeS4aZxJxZHEDJTRN1SW6VVjBzGQ@mail.gmail.com>
	<20140602151454.GK32082@beef>
	<CABb+yY3ZYqtT+R0PwZDtpW0O0SsbxTyiYmXaseZHoj4Nr6UBPQ@mail.gmail.com>
	<CAPKp9uZTnWCojeZHyvrm=vTuY15dAHiW1CWP18JUfuKU-mfH0Q@mail.gmail.com>
	<CAJe_ZheA_2PwzFGwx2rdba0oVsAKRnwK02XE-8nPY6K5NKpdTw@mail.gmail.com>
	<20140605111205.GD32082@beef>
Date: Thu, 5 Jun 2014 17:09:22 +0530
Message-ID: <CAJe_ZheUpALkb9+8W_DNu=WGHMn0N+7Ctik6DNJZiARVsbR35Q@mail.gmail.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Devicetree List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 16:42, Matt Porter <mporter@linaro.org> wrote:
> On Tue, Jun 03, 2014 at 03:51:55PM +0530, Jassi Brar wrote:
>
>> BTW, here we at least have a hardware resource to specify in the DT
>> node, there are examples in kernel where the DT nodes are purely
>> virtual. For ex, grep for "linux,spdif-dit". So I think we should be
>> ok.
>>
>
> There's a bit of a difference between my concern over a virtual node and
> this example you've cited. In the dummy spdif transmitter, it's defining
> a virtual device that plugs in for a codec, a hardware concept well
> defined in the audio bindings. I agree that there are many examples of
> this type of virtual node, including dummy phys, but in all cases they
> are stubbing out a real hardware concept.
>
> I find it to be distinctly different to create a node that doesn't
> represent the hardware's use of mailboxes.
>
The way I see "cpm_ipc" is that it represents a device that doesn't
need MMIO or an IRQ, but only the mailbox hardware resource.
"linux,spdif-dit" needs no hardware resource at all. So if anything,
more "virtual" than cpm_ipc.

> I'd be happy if a DT
> maintainer could say that this is acceptable though. ;)
>
OK, though it becomes clear only after reading this ;)

Cheers
-Jassi
