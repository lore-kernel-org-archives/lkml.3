Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaJUREK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:04:10 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34912 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbaJUREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <1413881397.30379.7.camel@hadess.net>
References: <1413881397.30379.7.camel@hadess.net>
Date: Tue, 21 Oct 2014 10:04:08 -0700
X-Google-Sender-Auth: tr23CGce0Og00u_30RZYLUZebVE
Message-ID: <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>
Subject: Re: A desktop environment[1] kernel wishlist
From: John Stultz <john.stultz@linaro.org>
To: Bastien Nocera <hadess@hadess.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 1:49 AM, Bastien Nocera <hadess@hadess.net> wrote:
> Hey,
>
> GNOME has had discussions with kernel developers in the past, and,
> fortunately, in some cases we were able to make headway.
>
> There are however a number of items that we still don't have solutions
> for, items that kernel developers might not realise we'd like to rely
> on, or don't know that we'd make use of if merged.
>
> I've posted this list at:
> https://wiki.gnome.org/BastienNocera/KernelWishlist
>
> Let me know on-list or off-list if you have any comments about those, so
> I can update the list.

As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
documentation'

Can you expand more on the rational for the need here? Is this for UI
for power debugging, or something else?

thanks
-john
