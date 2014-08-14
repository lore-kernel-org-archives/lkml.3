Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaHNPav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:30:51 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:41916 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaHNPau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:30:50 -0400
MIME-Version: 1.0
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
	<20140806095012.GN30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
	<20140806125550.GO30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
	<20140807121248.GY30282@n2100.arm.linux.org.uk>
	<20140808180900.GG30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
	<CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
Date: Thu, 14 Aug 2014 12:30:46 -0300
Message-ID: <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
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

On Thu, Aug 14, 2014 at 11:43 AM, Mattis Lorentzon
<Mattis.Lorentzon@autoliv.com> wrote:

> After a few more tests we have finally been able to trigger the exact same stalls
> on the Sabrelite board with a direct network connection (i.e. without the switch).

Do the stalls also happen on a pure 3.16 kernel?

How can we reproduce the error?
