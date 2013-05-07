Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab3EGQ4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:56:11 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:47292 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGQ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <51885FC4.7000401@gmail.com>
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
	<1367825063-6263-1-git-send-email-jaswinder.singh@linaro.org>
	<51885FC4.7000401@gmail.com>
Date: Tue, 7 May 2013 22:26:07 +0530
Message-ID: <CAJe_ZheEut1fbifGeWfiZmar0zm_ZgdzygeaAYTOitSR_tqbiA@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] mailbox: pl320: Introduce common API driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, "Anna, Suman" <s-anna@ti.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2013 07:28, Rob Herring <robherring2@gmail.com> wrote:
> On 05/06/2013 02:24 AM, Jassi Brar wrote:
>> Convert the PL320 controller driver to work with the common
>> mailbox API. Also convert the only user of PL320, highbank-cpufreq.c
>> to work with thee API. Drop the obsoleted driver pl320-ipc.c
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>> ---
>>  drivers/cpufreq/highbank-cpufreq.c |   22 +++-
>>  drivers/mailbox/Makefile           |    2 +-
>>  drivers/mailbox/pl320-ipc.c        |  198 ---------------------------------
>>  drivers/mailbox/pl320.c            |  212 ++++++++++++++++++++++++++++++++++++
>
> Can you resend this using git format-patch -M option.
>
IIRC I already did that. Anyways I just checked -M doesn't produce
anything different for the patch. Except for headers, defines and
module init rituals, everything else is from scratch.

-Jassi
