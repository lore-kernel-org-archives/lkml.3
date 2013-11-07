Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3KGKUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:20:11 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:33505 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3KGKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:20:07 -0500
Message-ID: <527B68D7.2030403@ahsoftware.de>
Date: Thu, 07 Nov 2013 11:17:59 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Keith Curtis <keithcu@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>	<5277D2C3.3020203@ahsoftware.de>	<CAMuHMdUHcbHXa8YAvyRMG1+ww6yLZtiXdab47VT5EqY9oe_LtA@mail.gmail.com>	<52782793.8040103@ahsoftware.de> <CAHW+f2J8L8ys-=Eszf4QQHOkr=vC9nVv63Pz4v_=wZNxWCjDvQ@mail.gmail.com>
In-Reply-To: <CAHW+f2J8L8ys-=Eszf4QQHOkr=vC9nVv63Pz4v_=wZNxWCjDvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2013 14:42, schrieb Keith Curtis:
> I don't know if you all should spend time working only on bugs, but I
> believe more time should be spent on the bug *list*. There are many
> users patiently waiting for the kernel to work for their computer. The
> pleas for help can be read in the bug database. The data can be used
> to determine the selective places in the code that need more
> brainpower. Send in the cavalry! Some have been waiting for years. I'm
> running into 9 kernel / X bugs on my new Lenovo Yoga 2 with 3.11.6. An
> unprioritized buglist also discourages people from entering new, valid
> ones. As the issue list gets in better shape, things will become a bit
> more relaxed. Quality metrics around bug count and age can be useful.

The problem with many bugs is, that workarounds don't get accepted.

So the situation sometimes is that there is a driver which isn't that 
perfect and when you try to fix something, the patch is refused because 
it is as imperfect as the whole driver (even if the patch would cure 
some problems).
So the only fix which won't be refused is a rewrite of the driver which 
often just isn't what people are willing to do.

Regards,

Alexander Holler

