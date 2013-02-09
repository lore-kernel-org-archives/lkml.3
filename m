Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab3BIOS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:18:26 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:37662 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3BIOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130209132435.169133E30EC@localhost>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-8-git-send-email-acourbot@nvidia.com> <20130209132435.169133E30EC@localhost>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 9 Feb 2013 23:18:03 +0900
X-Google-Sender-Auth: XdLWtgw8RMQjQwkmFZTv7txrFbo
Message-ID: <CAAVeFuLP0Deyr4hzW_XYDbQ0qehYaNydTrQzRo+B8saEcNLOFw@mail.gmail.com>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 10:24 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sun,  3 Feb 2013 01:29:29 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Make sure gpiolib works internally with descriptors and (chip, offset)
>> pairs instead of using the global integer namespace. This prepares the
>> ground for the removal of the global gpio_desc[] array and the
>> introduction of the descriptor-based GPIO API.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Despite Linus' comments, I've gone ahead and applied this. I think it is
> a worthwhile change on its own and it feeds into the future work than
> needs to be done. Any of the stuff he brought up can be addressed in
> follow-on patches.

Ah, I actually wanted to ask you for a couple of days to submit a new
version of this. On top of Linus' comments, there are a few more
sanity checks I'd like to add. If you don't want to rebase on the new
version, I can also send a new patch on top of this one, whichever way
you prefer - but I think rebasing would be cleaner, if you don't mind.

Alex.
