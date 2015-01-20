Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbbATKzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:55:21 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:55279 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbbATKzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:55:18 -0500
MIME-Version: 1.0
In-Reply-To: <8761c191k8.fsf@dell.be.48ers.dk>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
 <1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
 <87k30i9ykv.fsf@dell.be.48ers.dk> <CAPybu_180vMPMx4yhFAoL9H2b34+tWtqQCTHjxqkTRt9e_VA5g@mail.gmail.com>
 <8761c191k8.fsf@dell.be.48ers.dk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:54:55 +0100
Message-ID: <CAPybu_0qdumx91RFERp5Ft2HXs6rYv5H0WTFxiiyT4oiGjmzhA@mail.gmail.com>
Subject: Re: [PATCH 7/8] gpio/mpc8xxx: Convert to platform device interface.
To: Peter Korsgaard <peter@korsgaard.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No worries :)

On Tue, Jan 20, 2015 at 11:41 AM, Peter Korsgaard <peter@korsgaard.com> wrote:
>>>>>> "Ricardo" == Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> writes:
>
>  > Hello Peter
>  > I thought the logic behind the original driver was:
>
>  > 1) Create gpiochip so it can be used by other modules/userland
>  > 2) if there is also a irq available for it, create a irqdomain.
>  > otherwise continue.
>
> Indeed - Sorry, I must have been confused yesterday.
>
> --
> Bye, Peter Korsgaard



-- 
Ricardo Ribalda
