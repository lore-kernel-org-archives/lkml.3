Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaCYIAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:00:04 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39301 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaCYIAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:00:00 -0400
Date: Tue, 25 Mar 2014 07:59:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Subject: Re: New NAND driver
Message-ID: <20140325075954.GD21665@lee--X1>
References: <20140324132446.GA21665@lee--X1>
 <20980858CB6D3A4BAE95CA194937D5E73EAB561C@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAB561C@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morning Pekon,

> >From: Lee Jones
> >
> >Hi Brian,
> >
> >Firstly I'd like to thank you for supporting the inclusion of ST's SPI
> >NOR (FSM) driver. As promised I will convert it over to the new
> >framework once it has been applied by your good self.
> >
> >In the meantime however, I have a NAND driver which I need to
> >submit. I wanted to give you a heads-up prior to sending it in case
> >you had any special requests. FYI: Shoving it where the sun don't
> >shine, is not a valid request by the way :). It's 2700 lines and I've
> >split it over 47 patches for reviewing purposes.
> >
> Will it be possible for you to send the patches split in one patch per file ?
> As switching back and forth, between 47 patches may be bit troublesome.
> Later you may split it as you or others like..

There is only one file. I can send it as a single patch; however, when
I sent the NOR driver [1], it was considered helpful to review in
chunks, kinda how the driver was written. I'll send it as a set to
start with and if you think it creates more problems than it solves
then we'll do something about it.

[1] https://lkml.org/lkml/2014/3/20/103

> >Sorry to do this to you Brian, I am sensitive to how over-burdened you
> >are with the subsystem already. Perhaps it might make sense to put out
> >a plea for volunteers to help with maintain MTD subsystem on LKML?
> >
> I can help reviewing those patches, if you can please share your
> controller specs, and also share if there are any already know
> hardware limitations.

Thanks for your kind offer. I will send it right away.

> >Anyway, what's the best thing to do in this instance? Should I just
> >send it to the list as an RFC and be done with it?

Kind regards,
Lee

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
