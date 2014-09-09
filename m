Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaIIU7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:59:48 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54613 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaIIU7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140909024100.GA19119@Robin-OptiPlex-780>
References: <CAL8zT=hNnRU3gbprVXOMt6FC9veRvQKRmS9gSeCm5-DNfGv-xg@mail.gmail.com>
 <20140903125248.GK29327@sirena.org.uk> <20140909024100.GA19119@Robin-OptiPlex-780>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 9 Sep 2014 22:59:31 +0200
X-Google-Sender-Auth: CAsKxd-PgO9tVdeXCyNVX0awomQ
Message-ID: <CAL8zT=hf8T7P=7PJKK9_de2R8bHmm=O4ws3JbBqKBaTMR5DinA@mail.gmail.com>
Subject: Re: PFUZE100 regulator not going off when PWRON is 0
To: Robin Gong <b38343@freescale.com>
Cc: Mark Brown <broonie@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-09 4:41 GMT+02:00 Robin Gong <b38343@freescale.com>:
> Thanks for Mark's forward.
>
> Hi Jean-Michel,
>   Yes, SWxOMODE can be set as 1 to active sleep mode if PWRON turn-off event
> occurs. And the voltage of sleep mode can be set in other register SWxOFF. But
> by default, SWxOMODE is 0 which means all SW will be turned off while PWRON go
> form 1 to 0. For your issue, I hope you check the hardware design, and measure
> PWRON pin to see whether it has been pulled low once your push reset key.

Thank you both, we found an electrical issue which made it not going down to 0V.
Regards,
JM
