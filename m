Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3IWJIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:08:55 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45815 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab3IWJIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:08:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAJxxZ0ORrqjKB0ZHYz=-F2XMDv3TDiQWLwt=jWJTW0JaB2UX8w@mail.gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
	<1378196941-23390-2-git-send-email-sonic.adi@gmail.com>
	<CACRpkdaZNd55GLb+kx6ieZRbm=S+8s=izrzew2xH+vkYvdjOpQ@mail.gmail.com>
	<CAJxxZ0ORrqjKB0ZHYz=-F2XMDv3TDiQWLwt=jWJTW0JaB2UX8w@mail.gmail.com>
Date: Mon, 23 Sep 2013 11:08:53 +0200
Message-ID: <CACRpkdb54Oob-n7rbg28A_JHebOZxKPwV54kyU_Q_otvpXWAtQ@mail.gmail.com>
Subject: Re: [PATCH 2/3 v4] blackfin: gpio: Remove none gpio lib code.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:17 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> On Mon, Sep 23, 2013 at 3:48 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> Hi Sonic, I tried to apply this but it doesn't apply cleanly on
>> my pinctrl "devel" branch based off v3.12-rc1.
>>
>> Can you rebase patch 2+3 and resend?
>
> The patch 2 is already in your "devel" branch of kernel v3.12-rc1.
> Please apply patch 3 only.

Yes sorry I was confusing myself by missing to check my own trees,
what a mess. Applied #3 now.

Yours,
Linus Walleij
