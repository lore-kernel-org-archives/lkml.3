Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaHENxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:53:24 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:59527 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaHENxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
	<20140626140115.GQ32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
	<20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
Date: Tue, 5 Aug 2014 10:53:21 -0300
Message-ID: <CAOMZO5BdPKZSV4mQMA+vCJFpZ2KV6fooLNH2TvfvvVto+Eb2JA@mail.gmail.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
From: Fabio Estevam <festevam@gmail.com>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 10:31 AM, Mattis Lorentzon
<Mattis.Lorentzon@autoliv.com> wrote:

> We have applied your V2 patch set of 30 patches on top of v3.16-rc2 and are
> currently running some stability tests.
>
> During our first test round we triggered a timeout which caused the fec driver
> to become unresponsive for several minutes. The attached backtrace was
> shown when the hardware was rebooted.

Could this problem be the same one as reported at:
http://www.spinics.net/lists/arm-kernel/msg347914.html ?

Which Ethernet PHY do you use? Do you have pull-up in the MDIO line?
