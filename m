Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab3GOQjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:39:15 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:52113 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab3GOQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5C_7nJ9RVYvuKJHP2u0mYY6P2UyGVA6OpPzqTnd7YXN2Q@mail.gmail.com>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
	<CAOMZO5C_7nJ9RVYvuKJHP2u0mYY6P2UyGVA6OpPzqTnd7YXN2Q@mail.gmail.com>
Date: Mon, 15 Jul 2013 13:39:13 -0300
X-Google-Sender-Auth: xLLbsZndK-DAoe0A6YhzbniTo5M
Message-ID: <CAP9ODKpr82mMoxhiv=K70RKdn01b=ZM2J9E4vV-AM5nwXxUR+g@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: dts: imx23-evk: enable USB PHY and controller
From: Otavio Salvador <otavio@ossystems.com.br>
To: Fabio Estevam <festevam@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 12:39 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Otavio,
>
> On Mon, Jul 15, 2013 at 11:22 AM, Otavio Salvador
> <otavio@ossystems.com.br> wrote:
>> The i.MX23EVK board provides a USB port so the USB PHY and controller
>> need to be enabled for it to be usable.
>>
>> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
>> ---
>
> You should have Cc'd Shawn Guo on this series.

Oh; thanks for fix my mistake. I am new to kernel development :-)

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
