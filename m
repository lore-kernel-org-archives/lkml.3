Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaA3Vrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:47:39 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:64250 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaA3Vrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:47:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAGa+x85md++qtw5n7c_4L-MvaK8nB3c8GpFf+OLb4p--8N=+og@mail.gmail.com>
References: <20140130111919.afc7f4e5b58e409aaabf7550@canb.auug.org.au> <CAGa+x85md++qtw5n7c_4L-MvaK8nB3c8GpFf+OLb4p--8N=+og@mail.gmail.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 30 Jan 2014 13:47:15 -0800
Message-ID: <CAPtuhTgAF7u-yZi3OpmAPikhp25nu+ooqEQXbJELVKTkAaJh4A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with Linus' tree
To: Kevin Hilman <khilman@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Alex Elder <elder@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 9:33 PM, Kevin Hilman <khilman@linaro.org> wrote:
> On Wed, Jan 29, 2014 at 4:19 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> drivers/clk/Makefile between commit fd3fdaf09f26 ("clk: sort Makefile")
>> from Linus' tree and commit 7ee2c5117483 ("clk: bcm281xx: add initial
>> clock framework support") from the arm-soc tree.
>
> Ugh.  Looks like some last minute cleanup stuff went into clk-next
> that didn't spend time in linux-next, and now causes conflicts with
> some clk stuff we still have queued in arm-soc (ack'd by Mike.)
>
> Now, based on the Hulk's response to Mike's pull request, if we submit
> this, introducing yet more conflicts in the Makefile, it will surely
> be Hulk angry, Hulk smash.

Well this is clearly my fault. Please place appropriate blame on me
for sneaking in that Makefile cleanup.

/me prepares to be smashed.

Regards,
Mike

>
> Kevin
