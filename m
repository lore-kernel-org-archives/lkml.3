Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3ETSeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:34:31 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:39404 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab3ETSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130520171304.GA5797@katana>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
	<1368702961-4325-15-git-send-email-wsa@the-dreams.de>
	<CACRpkda3NM0S_SSkm6aqyx=_i1GOFvJE6rCp29Wnmbo527itPQ@mail.gmail.com>
	<20130520171304.GA5797@katana>
Date: Mon, 20 May 2013 20:34:29 +0200
Message-ID: <CACRpkdZG9T3jUOTHx=rckPmDTmQ49PwRGSV22g=MECP2piOb5g@mail.gmail.com>
Subject: Re: [PATCH 14/33] drivers/pinctrl: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 7:13 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Mon, May 20, 2013 at 01:39:28PM +0200, Linus Walleij wrote:
>> On Thu, May 16, 2013 at 1:15 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
>>
>> > devm_ioremap_resource does sanity checks on the given resource. No need to
>> > duplicate this in the driver.
>> >
>> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
>>
>> I think I have already applied this?
>
> Ah, you already applied the RFC? Shouldn't matter. Linus pulled this
> series meanwhile, too.

I realized that a bit later, OK no problem, I'll get it out of my
tree somehow.

Yours,
Linus Walleij
