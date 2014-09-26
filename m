Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaIZMak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:30:40 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51490 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaIZMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:30:38 -0400
MIME-Version: 1.0
In-Reply-To: <1411734282.7866.31.camel@x220>
References: <1411733700.7866.29.camel@x220>
	<CAOQ7t2Y0+OMab1CGGegUU+oOPaw=_NAxwM0LKn9GpiMZqAFnvg@mail.gmail.com>
	<1411734282.7866.31.camel@x220>
Date: Fri, 26 Sep 2014 14:30:38 +0200
X-Google-Sender-Auth: 1vnMlZgH87ULfwo9MSuIk-5lI7E
Message-ID: <CAOQ7t2bDBfU+hPZkpRX0m-kWh-ONiiu1_2boxh9ud6BhSt=A5g@mail.gmail.com>
Subject: Re: ARM: meson: MESON6_TIMER?
From: Carlo Caione <carlo@caione.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Carlo Caione <carlo@caione.org>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 2:24 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Fri, 2014-09-26 at 14:21 +0200, Carlo Caione wrote:
>> Yes. The timer support is going to be added with:
>>
>> http://www.spinics.net/lists/arm-kernel/msg362483.html
>>
>> Daniel is already on it.
>
> I probably won't have to bother you again. Thanks!

No problem. It is my fault.
I left the select statement and the DTS node in when the original
patchset [0] was split in two parts.
Sorry for the trouble.

[0] http://www.spinics.net/lists/arm-kernel/msg361789.html

-- 
Carlo Caione
