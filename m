Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaCFKwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:52:17 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52236 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaCFKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140228092203.GA2974@piout.net>
References: <1375189476-21557-1-git-send-email-coelho@ti.com>
 <CAGm1_kvdzkvzEEymQ+H0XiKugifHF27KDz3jwX5Frg_U=S7KgA@mail.gmail.com> <20140228092203.GA2974@piout.net>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Thu, 6 Mar 2014 11:51:54 +0100
Message-ID: <CAGm1_kv_byZMme0amziQt57Wng+b342hPf5MKrJn2iFRvdyR5Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] wilink: add device tree support
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: mark.rutland@arm.com, nm@ti.com, Mike Turquette <mturquette@linaro.org>,
        linux-doc@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, "Nori, Sekhar" <nsekhar@ti.com>,
        kernel list <linux-kernel@vger.kernel.org>, balbi@ti.com,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org,
        luca@coelho.fi,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 10:22 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> On 28/02/2014 at 08:26:46 +0100, Yegor Yefremov wrote :
>>
>> What is the state of the series? Who is now responsible for the
>> patches? What issues were still not handled?
>>
>
> We probably want to end that discussion before taking those bindings in:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-February/232185.html
>
> I've hit the issue, precisely using those bindings.

The discussion seems to flow down. The last message was about "Mon Feb
17 18:25:11 EST 2014".

Btw is TI going to assign a new maintainer for Wilink stuff? As Luca
has left TI, the driver is marked as "Orphan".

Yegor
