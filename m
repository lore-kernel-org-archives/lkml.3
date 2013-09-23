Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3IWDTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 23:19:13 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:35857 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3IWDTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 23:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZbB2cq2Ad3Tkoj05DBz4qp7TNSM64tLFv6e6z49bqnKw@mail.gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
	<CACRpkdZbB2cq2Ad3Tkoj05DBz4qp7TNSM64tLFv6e6z49bqnKw@mail.gmail.com>
Date: Mon, 23 Sep 2013 11:19:11 +0800
Message-ID: <CAMk6uB=PX+m+1pFOTxsChuMixWRmdLW_i8tKp4Ev9Xn5u3m+mw@mail.gmail.com>
Subject: Re: [PATCH 1/3 v4] pinctrl: ADI PIN control driver for the GPIO
 controller on bf54x and bf60x.
From: Steven Miao <realmz6@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sonic Zhang <sonic.adi@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Grant Likely <grant.likely@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Sep 19, 2013 at 8:45 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Sep 3, 2013 at 10:28 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
>> processors. It differs a lot from the old one on BF5xx processors. So,
>> create a pinctrl driver under the pinctrl framework.
> (...)
>> v4-changes:
> (...)
>
> I'm quite happy with v4, and applied it to my devel branch
> in the pinctrl tree so we get some rotation in linux-next.
>
> If I can get an ACK from the Blackfin maintainer on patches
> 2 and 3 I'll apply those as well so you don't have to pull
> the pinctrl tree into blackfins tree, Mike?
Pls apply those patches to your pinctrl tree, thanks.

-steven
>
> Yours,
> Linus Walleij
