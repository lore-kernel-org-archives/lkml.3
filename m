Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaGKWJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:09:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45517 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaGKWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org>
	<1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org>
Date: Fri, 11 Jul 2014 15:09:03 -0700
Message-ID: <CAPdLdqmBUFaCjdLrYJh3P2jizYC3GP0g7ut+FNaLQ5a73gMp0w@mail.gmail.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
From: Markus Mayer <markus.mayer@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
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
        ashwin.chaugule@linaro.org, bjorn@kryo.se,
        Patch Tracking <patches@linaro.org>, Mollie.Wu@tw.fujitsu.com,
        t.takinishi@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 02:35, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
>
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  .../devicetree/bindings/mailbox/mailbox.txt        |  33 ++
>  Documentation/mailbox.txt                          | 107 +++++
>  MAINTAINERS                                        |   8 +
>  drivers/mailbox/Makefile                           |   4 +
>  drivers/mailbox/mailbox.c                          | 490 +++++++++++++++++++++
>  include/linux/mailbox_client.h                     |  48 ++
>  include/linux/mailbox_controller.h                 | 128 ++++++
>  7 files changed, 818 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/mailbox.txt
>  create mode 100644 Documentation/mailbox.txt
>  create mode 100644 drivers/mailbox/mailbox.c
>  create mode 100644 include/linux/mailbox_client.h
>  create mode 100644 include/linux/mailbox_controller.h

I don't think combining code and documentation like this is the right
approach. As per
Documentation/devicetree/bindings/submitting-patches.txt:

"1) The Documentation/ portion of the patch should be a separate patch."

I am not sure if binding document and regular documentation should be
separated out or if they can stay together  (those more knowledgeable,
please comment!), but the code portion should definitely be a separate
patch from the documentation.

Regards,
-Markus
