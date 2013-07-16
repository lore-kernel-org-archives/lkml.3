Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab3GPMZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:25:18 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59071 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3GPMZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130716013002.GC28375@S2101-09.ap.freescale.net>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
	<CAOMZO5C_7nJ9RVYvuKJHP2u0mYY6P2UyGVA6OpPzqTnd7YXN2Q@mail.gmail.com>
	<CAP9ODKpr82mMoxhiv=K70RKdn01b=ZM2J9E4vV-AM5nwXxUR+g@mail.gmail.com>
	<20130716013002.GC28375@S2101-09.ap.freescale.net>
Date: Tue, 16 Jul 2013 09:25:16 -0300
X-Google-Sender-Auth: xUDnzQcTogRokqWYc1j7UgXIjLc
Message-ID: <CAP9ODKqrXBybj=Xk5NsXQRvyOWppCEgR+CgzB1C=d0v2NXj4AQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: dts: imx23-evk: enable USB PHY and controller
From: Otavio Salvador <otavio@ossystems.com.br>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>, Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 10:30 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Mon, Jul 15, 2013 at 01:39:13PM -0300, Otavio Salvador wrote:
>> On Mon, Jul 15, 2013 at 12:39 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> > Hi Otavio,
>> >
>> > On Mon, Jul 15, 2013 at 11:22 AM, Otavio Salvador
>> > <otavio@ossystems.com.br> wrote:
>> >> The i.MX23EVK board provides a USB port so the USB PHY and controller
>> >> need to be enabled for it to be usable.
>> >>
>> >> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
>> >> ---
>> >
>> > You should have Cc'd Shawn Guo on this series.
>>
>> Oh; thanks for fix my mistake. I am new to kernel development :-)
>
> I'm on copy of patches 1, 3 and 4.  2 and 5 are missing?

I will prepare a v2, as per Jonathan feedback and will add you in all them.

--
Otavio Salvador                             O.S. Systems
http://www.ossystems.com.br        http://projetos.ossystems.com.br
Mobile: +55 (53) 9981-7854            Mobile: +1 (347) 903-9750
