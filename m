Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaCDGkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:40:43 -0500
Received: from ni.piap.pl ([195.187.100.4]:43617 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaCDGkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:40:42 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        Shaun Laing <shaun@xresource.ca>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <3980699.cFzmTHesZE@daeseok-laptop.cloud.net>
	<m3bnxnpyok.fsf@t19.piap.pl>
	<CAHb8M2AS2w9VBSJS9imU07ydMOZW+M-PD-Ja3iZYSTJ=2GNa-A@mail.gmail.com>
Date: Tue, 04 Mar 2014 07:40:40 +0100
In-Reply-To: <CAHb8M2AS2w9VBSJS9imU07ydMOZW+M-PD-Ja3iZYSTJ=2GNa-A@mail.gmail.com>
	(DaeSeok Youn's message of "Mon, 3 Mar 2014 16:01:47 +0900")
MIME-Version: 1.0
Message-ID: <m34n3epitz.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [PATCH 3/5 v2] Staging: cxt1e1: Fix line length over 80 characters in hwprobe.c
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140303 #7388596, check: 20140304 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DaeSeok Youn <daeseok.youn@gmail.com> writes:

>>> -              * match with board's first found interface, otherwise this is first
>>> -              * found
>>> +              * match with board's first found interface, otherwise this is
>>> +              * fisrt found
>>                    ^^^^^
>> I wonder what's your exact procedure for doing such changes :-)
> "first" word is over 80 line character after applying my previous patch(2/5)
> (previous patch is already merged to staging-next tree :-))

Sure, I meant I'd just break the line without re-typing the first/fisrt
word manually... Never mind.

Anyway, I'd rather aim for improving overall code quality, not just
silence 80-char warning. I'm not a big fan of this warning.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
