Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928Ab3IDTVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:21:04 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60702 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529Ab3IDTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com>
References: <5226FAE1.5070201@fb.com>
	<CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com>
Date: Wed, 4 Sep 2013 12:20:58 -0700
X-Google-Sender-Auth: kRG2YIqdmXL3lmHgGzjR5SFiNzY
Message-ID: <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com>
Subject: Re: clock_gettime_ns
From: John Stultz <john.stultz@linaro.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Arun Sharma <asharma@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Kumar Sundararajan <kumar@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 11:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> I think that most of the hangup was a lack of agreement on how the API
> should work wrt leap seconds.

I don't recall this objection. The interface uses existing clockids,
so it probably should keep the existing leap-second behavior of those
clockids.

> I've always thought that the Right Way to represent a UTC time is
> nanoseconds since some epoch, where every potential leap second
> counts.

Check out the CLOCK_TAI clockid merged in 3.10.

thanks
-john
