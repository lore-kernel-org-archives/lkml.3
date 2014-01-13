Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaAMMPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:15:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46421 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:15:08 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbpXCns4Z+AiFuijnvLJ91ZgMjiwmZZLJ0owKW1Sr-+xw@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
	<CAOMwXhNyntnu7h_VOLWq3rh1EprNCnm8yByza6Bz-J9XQmA-sA@mail.gmail.com>
	<CACRpkdbpXCns4Z+AiFuijnvLJ91ZgMjiwmZZLJ0owKW1Sr-+xw@mail.gmail.com>
Date: Mon, 13 Jan 2014 12:15:07 +0000
X-Google-Sender-Auth: tPV9KbVJbyD-wnvOkvlvt16abg8
Message-ID: <CAOMwXhMx2E2UYNnC6+e3NRiTKyrEgqdc+Lz6VeTfJnV1EW=DbA@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Laszlo Papp <lpapp@kde.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 9:48 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jan 13, 2014 at 10:22 AM, Laszlo Papp <lpapp@kde.org> wrote:
>
>> I was giving a second thought to this. Would it be acceptable to add
>> the gpio driver now, and once the need arises, add the pinctrl thin
>> layer on top of it?
>
> I will not accept the platform data setting the pull-ups.

OK.

>> My concern is that I would not use anything else
>> than the gpio functionality of these pins. It would be a needless
>> additional work (i.e. investment) for my project and employer.
>
> But you are still expecting me as a subsystem maintainer to
> take responsibility of this driver for as long as I have this role?

Well, since we need to make sure that our product rocks and rolls, me
and my employer would need be committed for a quite while, but I can
understand where you are coming from.

> Rewriting code is a natural part of the community process,
> noone claimed it would be easy ;-)

Yes, it is difficult, especially for a C++/OOP person like me... I am
trying to do my best.

>> Perhaps, the layer on top of that can be added later without any
>> drawback if anyone ever finds the need to have more functionality
>> supported by these pins?
>
> Your driver already supports setting the pulls using a
> *custom* platform data field. This is not OK, and shall be
> implemented using the pin control subsystem. I will not
> merge drivers using custom platform data fields like this.
>
> The reason that the pin control subsystem even existed was
> that at the time my drivers were NACKed because I tried to
> shoehorn pin control into the GPIO subsystem, and as a
> result now we have an apropriate subsystem for it, so please
> use it.

OK, thanks.
