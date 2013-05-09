Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3EISLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:11:33 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:48339 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3EISLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:11:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwU3w2jiA26fCmF3_i+vpf8TMY+8L5=Oso_uMhZX30DQw@mail.gmail.com>
References: <CACxGe6uCJde0vw=zcqJOxdiwOJO8bRe00yzs6UDzup5z-jTRbw@mail.gmail.com>
 <CA+55aFwU3w2jiA26fCmF3_i+vpf8TMY+8L5=Oso_uMhZX30DQw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 9 May 2013 19:11:10 +0100
X-Google-Sender-Auth: SPcPGupE0f5thZckQjfulG4W9ss
Message-ID: <CACxGe6uybaWodG_F_=w7fF=w0X008E+HE7PuT=+a4zTG7-ug4A@mail.gmail.com>
Subject: Re: [git pull] GENERIC_GPIO removal
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 6:08 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 8, 2013 at 6:48 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>
>> * "git grep '\bGENERIC_GPIO\b'" should return 1 hit in the Chinese
>>   documentation.
>
> That's the oddest command line I've seen in some time.
>
> You do realize that "git grep" is perfectly happy to just take the
> "-w" flag exactly like normal grep?

Hahaha. That's just what Alexandre passed to me. I didn't really think
much about it.  :-)

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
