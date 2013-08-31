Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3HaQvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 12:51:10 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:34853 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3HaQvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 12:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <5221A28B.3060009@t-online.de>
References: <521A269D.3020909@t-online.de>
	<521C5493.1050407@cisco.com>
	<521C72FF.5070902@t-online.de>
	<5221A28B.3060009@t-online.de>
Date: Sat, 31 Aug 2013 09:51:07 -0700
X-Google-Sender-Auth: uvajBmGzGn9iFEtK9L0WBs-rdmo
Message-ID: <CA+55aFzau2ocCcBmV8Z7ULaom4vgTJ_J5gsQxAWpx=Q91ERiRQ@mail.gmail.com>
Subject: Re: [REGRESSION 3.11-rc1+] wm8775 9-001b: I2C: cannot write ??? to
 register R??
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 1:00 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> Hi Linus!
>
> It would be nice to have head cx88fix of
> git.linuxtv.org/hverkuil/media_tree.git
> (git.linuxtv.org/hverkuil/media_tree.git/commit/5dce3635bf803cfe9dde84e00f5f9594439e6c02)
> in 3.11 as it is a trivial and tested fix for a regression introduced
> between 3.10 and 3.11-rc1.

I can't take partial pull requests - I can take individual patches
from email (with proper sign-off chains etc, of course), but I don't
do "take this patch from this git tree". Git pulls need to go through
the tree owner and with all the normal pull request rules, and the
rest of that tree doesn't look critical.

                Linus
