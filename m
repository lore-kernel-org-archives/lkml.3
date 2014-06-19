Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaFSMON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:14:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49827 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbaFSMOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhfTCw3OHNeSTW71bc6U2g_d=5hYknu+dwhBkuZvPg=D6w@mail.gmail.com>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
	<1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
	<7hionz9i5e.fsf@paris.lan>
	<CAJe_ZhcuOa39Db_tE4JupY74aze02=v1FWzduFD0sO15nMrKvw@mail.gmail.com>
	<7hzjha5ew2.fsf@paris.lan>
	<CAJe_ZhfTCw3OHNeSTW71bc6U2g_d=5hYknu+dwhBkuZvPg=D6w@mail.gmail.com>
Date: Thu, 19 Jun 2014 08:14:10 -0400
Message-ID: <CAJ5Y-ebGpiVaUR5803wdGTegBqzd2Fdmhn7gFdRihfQ8ESi32w@mail.gmail.com>
Subject: Re: [PATCHv7 2/5] mailbox: Introduce framework for mailbox
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Patch Tracking <patches@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>,
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

Hello,

On 18 June 2014 22:55, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>
>> I sure would like to see some more Reviewed-by tags from those folks to
>> confirm that those starting to use it think it's on the right track.
>>
> The upstreaming attempts have been going on for months now, and via
> non-public interactions with developers I understand it last worked
> before the revision mandating DT support and ipc->mailbox symbol
> renaming. So basic working should still remain the same.
>    Suman(TI), Loic(ST), Girish(Samsung), Ashwin (PCC+ACPI).... guys,
> any word for v7?


V7 looks fine overall but it needs some minor changes for ACPI.
Something along the lines of what I submitted previously.[1]

[1] - http://www.spinics.net/lists/linux-acpi/msg51156.html

Cheers,
Ashwin
