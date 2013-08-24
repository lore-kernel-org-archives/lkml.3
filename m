Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3HXQzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 12:55:18 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:23689 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab3HXQzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 12:55:16 -0400
Message-ID: <5218E56D.3010508@c-s.fr>
Date: Sat, 24 Aug 2013 18:55:09 +0200
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roland Stigge <stigge@antcom.de>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] MAX7301 GPIO: Reverting "Do not force SPI speed when
 using OF Platform"
References: <201308200629.r7K6TNUS010648@localhost.localdomain> <CACRpkdbUv+59qZs1m3QUq11aad5RC-V-d1-TZeADjfy==Yu-+w@mail.gmail.com>
In-Reply-To: <CACRpkdbUv+59qZs1m3QUq11aad5RC-V-d1-TZeADjfy==Yu-+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 130824-0, 24/08/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 23/08/2013 19:47, Linus Walleij a écrit :
> On Tue, Aug 20, 2013 at 8:29 AM, Christophe Leroy
> <christophe.leroy@c-s.fr> wrote:
>
>> This patch reverts commit 047b93a35961f7a6561e6f5dcb040738f822b892 which breaks
>> MAX7301 GPIO driver because that commit was dependant on a rejected patch that
>> was implementing selection of SPI speed from the Device Tree.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Patch applied with Roland's ACK.
>
> But seriously, this is the kind of stuff that scares me a lot,
> when developers merge dependent patches into two different
> trees, that is just a recipe for chaos and me getting flamed
> by other kernel maintainers.
>
> There is *no* mention of this dependency in the other
> commit.

I'm very sorry for this mishap. If I didn't mention it in the commit, 
this is because when I developped the change I submitted you a few 
months back, I was not aware of that other patch. It looks like it has 
been in my company's kernel tree for years, therefore in my mind it was 
a standard feature of the kernel. It looks like nobody had tried and 
submitted it for inclusion previously.
That's thanks to Roland that I discovered it was indeed not a standard 
feature, then I tried to submit that patch a week ago and it was 
rejected by Stephen Warren for good reason.
For me it is a lesson learnt, and I'll make sure it doesn't happen again.

Regards
Christophe
