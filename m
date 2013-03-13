Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab3CMSkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:40:46 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:50943 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3CMSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:40:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130313175053.GQ12700@titan.lakedaemon.net>
References: <1362872371.3690.106.camel@shinybook.infradead.org>
	<1363196155-1620-1-git-send-email-jason@lakedaemon.net>
	<CACRpkdaoF-PqqOi3bCQXnuey_2U+niHA8RWriXiJUE=kUZB0dQ@mail.gmail.com>
	<20130313175053.GQ12700@titan.lakedaemon.net>
Date: Wed, 13 Mar 2013 19:40:43 +0100
Message-ID: <CACRpkdamWpNpwSL1OS4TDaAfzZtKyy54VzaA2nReu3hYOcYBMw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: mvebu: prevent walking off the end of group array
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 6:50 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Wed, Mar 13, 2013 at 06:47:36PM +0100, Linus Walleij wrote:
>> On Wed, Mar 13, 2013 at 6:35 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>>
>> > From: David Woodhouse <dwmw2@infradead.org>
>> >
>> > While investigating (ab)use of krealloc, David found this bug.  It's
>> > unlikely to occur, but now we detect the condition and error out
>> > appropriately.
>> >
>> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
>> > ---
>> > David, please double check that this is as you intended.  I had to hand-jam it in due to some peculiarities on my side.
>>
>> I have tentatively applied this to my fixes branch.
>
> Dang, you're quick.  Please see V2 <shuffles feet>

Ah, I'm too trigger happy. I took it out again waiting for some ACK
and testing..

Yours,
Linus Walleij
