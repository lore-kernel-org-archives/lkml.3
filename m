Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3AWFIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:08:01 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:38138 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3AWFH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:07:59 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYt8CoF0_yrMkNE20fhKnRuG-=yxr2XsQKPgMWD=ehUNA@mail.gmail.com>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com>
	<50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com>
	<CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
	<20130114002608.GV23505@n2100.arm.linux.org.uk>
	<CACRpkdbVPeva08nL_FP7qw0MeKLz6h40kPHAz_W95ZBGraOnpg@mail.gmail.com>
	<CAOAMb1BgcvBb6KHaZbwbh0rq8r1WfAtdCeZJexfaYoOwGfU7Sg@mail.gmail.com>
	<CAOAMb1BS6gvezeSrUTNJ--gGxCRL17AO8PHJ_eLrxzjOex7w1g@mail.gmail.com>
	<CAOAMb1C=b2fXqKJKx1ZR7UD7n=c7qQoLnMgMmy2FXEubyP=dtw@mail.gmail.com>
	<CACRpkdYt8CoF0_yrMkNE20fhKnRuG-=yxr2XsQKPgMWD=ehUNA@mail.gmail.com>
Date: Wed, 23 Jan 2013 14:07:57 +0900
X-Google-Sender-Auth: PFGhdqRsWUAKgJCmLXqfWvpvahE
Message-ID: <CAOAMb1ACPx6iXWDYz7LnrbRLkLmK9HU7Lro7H5gqpSKr24ooVA@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:18 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
>> - If poll timer is activated, We use consistent DMA mappings to avoid from
>>   the frequent cache operation of the timer function. sg->coherency is used
>>   to check if buffer is coherent.
>
> Hm. We can begin like this but maybe we should later patch it to
> make this the default unless it has performance impacts on our
> systems.
Good, I really hope to make this the default.
We expect it has no impact to system even if no polling use.

> Maybe this is a good opportunity to add some kerneldoc above
> this struct so as to help platform implementers. It will invariably
> be reused by Device Tree binding authors later on...
Agree, but, frankly I need help about what I didn't modify.
So We will leave this work for the next submit.

Thanks
Chanho
