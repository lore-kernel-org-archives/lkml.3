Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaLXRNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:13:54 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:62336 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaLXRNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:13:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141224163823.GA17035@amd>
References: <20141224163823.GA17035@amd>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Dec 2014 09:13:32 -0800
Message-ID: <CALCETrW8nrKSZ800C+WaHMK4DCuWnD9TG3dYo7cZwm5j4CpNJQ@mail.gmail.com>
Subject: Re: DRAM unreliable under specific access patern
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 8:38 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> It seems that it is easy to induce DRAM bit errors by doing repeated
> reads from adjacent memory cells on common hw. Details are at
>
> https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
>
> . Older memory modules seem to work better, and ECC should detect
> this. Paper has inner loop that should trigger this.
>
> Workarounds seem to be at hardware level, and tricky, too.

One mostly-effective solution would be to stop buying computers
without ECC.  Unfortunately, no one seems to sell non-server chips
that can do ECC.

>
> Does anyone have implementation of detector? Any ideas how to work
> around it in software?
>

Platform-dependent page coloring with very strict, and impossible to
implement fully correctly, page allocation constraints?

--Andy

>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
