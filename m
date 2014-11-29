Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaK2JEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:04:09 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62414 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaK2JEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:04:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141129095632.69361457@wiggum>
References: <1417213013-19758-1-git-send-email-xerofoify@gmail.com>
	<CACna6rxmOC0h9hOpa=5iWFM1THQ8Q4hCi8MnmqkZJbB_U0PJ0A@mail.gmail.com>
	<20141129002148.1beb21d9@wiggum>
	<54793E4E.7050602@gmail.com>
	<20141129095632.69361457@wiggum>
Date: Sat, 29 Nov 2014 10:04:02 +0100
Message-ID: <CACna6ryjZ-LY06wAMzoL77Wca3McUUT+VYsO4EPO87NqjBnaNw@mail.gmail.com>
Subject: Re: [PATCH] drivers:net:wireless: Add mutex locking for function,
 b43_op_beacon_set_time in main.c
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: nick <xerofoify@gmail.com>, Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2014 at 09:56, Michael Büsch <m@bues.ch> wrote:
> On Fri, 28 Nov 2014 22:32:30 -0500
> nick <xerofoify@gmail.com> wrote:
>
>> I don't have hardware for this driver on me, so I didn't test it. However this seems to
>> be correct from my reading of the code around this function and other locking related
>> to this driver.
>
> From the current docs:
>
>>  * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
>>  *      must be set or cleared for a given STA. Must be atomic.
>
> So it is not allowed to lock a mutex here.

Nicholas please be more careful with your patches. It seems your patch
is wrong, you didn't check the docs and you didn't even say in the
first place that it wasn't tested. You could at least submit with with
RFT tag or sth.

-- 
Rafał
