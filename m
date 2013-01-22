Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3AVNEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:04:12 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:49756 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3AVNEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUJq-CWeYqrQMdxeb4WXrHRRZn05npWxRGYnGX=V+7OEQ@mail.gmail.com>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
	<CAMuHMdUJq-CWeYqrQMdxeb4WXrHRRZn05npWxRGYnGX=V+7OEQ@mail.gmail.com>
Date: Tue, 22 Jan 2013 14:04:06 +0100
Message-ID: <CACRpkdanK7J8wXZ_UqFUEKdAt-veTFLVoSHqa9F1Xdzdoa1pNg@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 1:25 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Jan 22, 2013 at 9:03 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> 1.  Get hold of the patch fixing the boot regression:
>>     git format-patch
>> f5565295892eb93c3191aa241405fe8b685542d6^..f5565295892eb93c3191aa241405fe8b685542d6
>
> git format-patch -1 f5565295892eb93c3191aa241405fe8b685542d6

Ah, I always wondered if there was a better way to do that,
thanks Geert!

Yours,
Linus Walleij
