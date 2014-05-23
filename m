Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaEWWBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:01:49 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43189 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEWWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:01:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:f9b2:89f2:5bde:a33c]
In-Reply-To: <20140523215544.GI13642@piout.net>
References: <1400775895-31183-1-git-send-email-nicolas.ferre@atmel.com>
	<201405232327.52312.arnd@arndb.de>
	<20140523215544.GI13642@piout.net>
Date: Fri, 23 May 2014 15:01:47 -0700
Message-ID: <CAOesGMioT1QSaBY6vs30E5ez5OouzaHhZE8dTEK1Rf0NekCZjg@mail.gmail.com>
Subject: Re: [GIT PULL] at91: DT for 3.16 at91-dt3 #3
From: Olof Johansson <olof@lixom.net>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        "arm@kernel.org" <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 2:55 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> On 23/05/2014 at 23:27:51 +0200, Arnd Bergmann wrote :
>> On Thursday 22 May 2014, Nicolas Ferre wrote:
>> > Another AT91 DT pull-request for 3.16. This one is the conversion of two more
>> > SoC to Common Clock Framework (aka CCF). I identified it as a "DT" pull-request
>> > but it modifies slightly a couple of files in mach-at91 (use of a configuration
>> > option).
>>
>> Four done, four more to go? Nice progress!
>>
>
> I'm on it ;) I actually have two more almost ready but I will submit the
> remaining four for 3.17. I don't think this is urgent enough to rush it
> and I'd like to test it enough before we start removing the old clock
> implementation and board files.

I think we should spend some more time discussing DTS naming instead!

(Just kidding, good progress. Agreed, let it go in when it's ready,
it's why we do frequent kernel releases)


-Olof
