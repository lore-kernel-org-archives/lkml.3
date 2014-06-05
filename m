Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaFELwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:52:30 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38655 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFELw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140605105127.GB32082@beef>
References: <1401733450-5646-1-git-send-email-jaswinder.singh@linaro.org>
	<1401733885-5896-1-git-send-email-jaswinder.singh@linaro.org>
	<20140605105127.GB32082@beef>
Date: Thu, 5 Jun 2014 17:22:27 +0530
Message-ID: <CAJe_ZhcwCF63Uryiguog3FH_aV5zptrhK_qoTKA0=bTvkOEP3w@mail.gmail.com>
Subject: Re: [PATCHv6 2/3] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Patch Tracking <patches@linaro.org>, Bjorn Andersson <bjorn@kryo.se>,
        Devicetree List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 June 2014 16:21, Matt Porter <mporter@linaro.org> wrote:
> On Tue, Jun 03, 2014 at 12:01:24AM +0530, Jassi Brar wrote:
>> Introduce common framework for client/protocol drivers and
>> controller drivers of Inter-Processor-Communication (IPC).
>>
>> Client driver developers should have a look at
>>  include/linux/mailbox_client.h to understand the part of
>> the API exposed to client drivers.
>> Similarly controller driver developers should have a look
>> at include/linux/mailbox_controller.h
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>> ---
>>  .../devicetree/bindings/mailbox/mailbox.txt        |  33 ++
>>  drivers/mailbox/Makefile                           |   4 +
>>  drivers/mailbox/mailbox.c                          | 487 +++++++++++++++++++++
>>  include/linux/mailbox_client.h                     |  45 ++
>>  include/linux/mailbox_controller.h                 | 121 +++++
>
> Could you please include all the DT maintainers here? It's a generic
> binding that needs wider review and an ack. The binding should be
> separated as noted below.
>
> From Documentations/devicetree/bindings/submitting-patches.txt:
>
> I. For patch submitters
>
>   0) Normal patch submission rules from Documentation/SubmittingPatches
>      applies.
>
>   1) The Documentation/ portion of the patch should be a separate patch.
>
>   2) Submit the entire series to the devicetree mailinglist at
>
>        devicetree@vger.kernel.org
>
Thanks. I missed CC'ing DT ML.  I remember patches with DT bindings
and parser code getting upstream... and actually see better sense in
that. But I guess I have to separate out the bindings.

Thanks
Jassi
