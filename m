Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaGNE4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 00:56:32 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61821 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaGNE4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 00:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAPdLdqmBUFaCjdLrYJh3P2jizYC3GP0g7ut+FNaLQ5a73gMp0w@mail.gmail.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
	<1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
	<CAPdLdqmBUFaCjdLrYJh3P2jizYC3GP0g7ut+FNaLQ5a73gMp0w@mail.gmail.com>
Date: Mon, 14 Jul 2014 10:26:22 +0530
Message-ID: <CAJe_ZhdrM1Th9MxDkYJo-_5n2BbF1KyByoWnZV+yxEDcEcHjYw@mail.gmail.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Device Tree List <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Girish K S <ks.giri@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, Suman Anna <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        "Mollie.Wu" <Mollie.Wu@tw.fujitsu.com>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2014 03:39, Markus Mayer <markus.mayer@linaro.org> wrote:
> On 11 July 2014 02:35, Jassi Brar <jaswinder.singh@linaro.org> wrote:
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
>>  Documentation/mailbox.txt                          | 107 +++++
>>  MAINTAINERS                                        |   8 +
>>  drivers/mailbox/Makefile                           |   4 +
>>  drivers/mailbox/mailbox.c                          | 490 +++++++++++++++++++++
>>  include/linux/mailbox_client.h                     |  48 ++
>>  include/linux/mailbox_controller.h                 | 128 ++++++
>>  7 files changed, 818 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
>>  create mode 100644 Documentation/mailbox.txt
>>  create mode 100644 drivers/mailbox/mailbox.c
>>  create mode 100644 include/linux/mailbox_client.h
>>  create mode 100644 include/linux/mailbox_controller.h
>
> I don't think combining code and documentation like this is the right
> approach. As per
> Documentation/devicetree/bindings/submitting-patches.txt:
>
> "1) The Documentation/ portion of the patch should be a separate patch."
>
Thanks, in fact the previous revision was split like that. But
encouraged by seeing many other instances, I took the liberty to club
them together because neither part makes sense without the other. Also
any reviewer looking at one has to look at the other too.

> I am not sure if binding document and regular documentation should be
> separated out or if they can stay together  (those more knowledgeable,
> please comment!), but the code portion should definitely be a separate
> patch from the documentation.
>
I am willing to learn and split the patchset again, if the gods want so..

Cheers,
Jassi
