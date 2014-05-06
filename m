Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaEFQd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:33:26 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:51886 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaEFQdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140506051133.GA30179@teo>
References: <1398268565-4789-3-git-send-email-dianders@chromium.org>
	<CAD=FV=W=Ffye5wp0PhJ2uX4jhEQkTKA4VTT4LyX2ZdByfE4UaQ@mail.gmail.com>
	<CAOesGMi+jH7xEzVxRX5qEoVycdtJ=FXOJRp1xut+65d4X8YFYA@mail.gmail.com>
	<20140506051133.GA30179@teo>
Date: Tue, 6 May 2014 09:33:23 -0700
X-Google-Sender-Auth: J3Kgzr1knPyc7MVtjs4yWY09TZ8
Message-ID: <CAD=FV=VYOXRq_mVjqcqu3FxE5D0ZG=nSu6s_5VENfZ+42B4WFQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v3 2/5] charger: tps65090: Allow charger module to
 be used when no irq
From: Doug Anderson <dianders@chromium.org>
To: Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton,

On Mon, May 5, 2014 at 10:11 PM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Mon, May 05, 2014 at 09:51:28AM -0700, Olof Johansson wrote:
>> > All the rest of this series has been acked and applied.  Do you have
>> > time to review this patch?
>> >
>> > Thanks!  :)
>>
>> FWIW, I've seen very little email traffic from Anton this year, he
>> might have limited time for maintainership at the moment.
>
> Yup.
>
> commit 573189354b7c97cd2256b87cf083ee435584594e
> Author: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Date:   Tue Jan 21 03:33:09 2014 +0400
>
>     MAINTAINERS: Pick up power supply maintainership
>
>     Anton stated that he would have to abandon power supply maintainership
>     due to the lack of time. By agreement with him and David, pick up power
>     supply tree.
>
>     Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>     Acked-by: Anton Vorontsov <anton@enomsg.org>

Doh, thanks for the pointer.


Dmitry: you were CCed on the patch.  Do you still have it in your
email somewhere?  I'm happy to repost it with you in the "To" line if
it's helpful.

Thanks!  :)

-Doug
