Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaBLUFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:05:50 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:47759 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbaBLUFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:05:22 -0500
MIME-Version: 1.0
X-Originating-IP: [84.208.70.35]
In-Reply-To: <mj+md-20140212.194230.3341.nikam@ucw.cz>
References: <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
 <mj+md-20131110.114139.9646.albireo@ucw.cz> <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
 <mj+md-20131215.091609.28546.nikam@ucw.cz> <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
 <mj+md-20131215.110132.29802.nikam@ucw.cz> <CAG-2HqUGcBB1-YUvLZpqm1EZ69OSksa+iGcCEqVWxYsehDqx8Q@mail.gmail.com>
 <CAG-2HqWYZtTMNRvLwWRy-5_5yb=EasiWzpL2xc0_42SyP=bg1w@mail.gmail.com>
 <CAG-2HqVS1avGdvi6SFc1dq0sCzcA4z5sZUBH4WhpNN87tZrnxA@mail.gmail.com> <mj+md-20140212.194230.3341.nikam@ucw.cz>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 12 Feb 2014 21:04:57 +0100
Message-ID: <CAG-2HqUN3Ftdd=3XSe-et3pgXy71Fu9DbMqREQDycwL4kD9Paw@mail.gmail.com>
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb support
To: Martin Mares <mj@ucw.cz>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 8:58 PM, Martin Mares <mj@ucw.cz> wrote:
> Hi!
>
>> Ping?
>
> Sorry for the delay, I was alternatingly ill and overloaded with other stuff...

No worries. I hope you are better now.

> As I said before, I do not like the current implementation of hwdb much (it's
> too much tied to Linux, and hardware description strings, originally intended
> for internal use between the kernel and its modules, are far from a nice API).
>
> I would prefer a more general HW identification library and I am willing to
> write it, but I have to admit that with my current load, it will be hardly
> finished before this summer.

Looking forward to seeing that.

> I will merge your patches. It's better to have the current hwdb than nothing.

Thanks!

Cheers,

Tom
