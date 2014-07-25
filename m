Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbaGYLYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:24:03 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45313 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGYLYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140724115252.1847dbad@endymion.delvare>
References: <20140721181507.5a6d3b2c@endymion.delvare>
	<CACRpkdZwoftk1bbmZYc5wSh8rzf137TURcjno5Am=CUUHVvEFw@mail.gmail.com>
	<20140724115252.1847dbad@endymion.delvare>
Date: Fri, 25 Jul 2014 13:24:00 +0200
Message-ID: <CACRpkdau4eAETDXy-SQPYPRfN6ixhiypZ32UUb6PXb2QMdTNag@mail.gmail.com>
Subject: Re: Run-time dependencies for STE Modem remoteproc driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:52 AM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi Linus,
>
> On Wed, 23 Jul 2014 17:21:17 +0200, Linus Walleij wrote:
>> On Mon, Jul 21, 2014 at 6:15 PM, Jean Delvare <jdelvare@suse.de> wrote:
>>
>> > This brings the question: on which architectures / platforms is the STE
>> > Modem remoteproc driver needed?
>>
>> NONE.
>
> Hm, OK :D So I will disable this driver in all our kernels. Maybe this
> should be mentioned in the Kconfig help text?
>
> Still, I suppose that the driver had an intended target, maybe we can
> use that as a run-time dependency? Or should we just make the driver
> depend on COMPILE_TEST?

Yeah that sounds like a pretty good idea actually, as we shouldn't
just delete it.

Yours,
Linus Walleij
