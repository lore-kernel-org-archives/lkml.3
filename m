Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3IWIRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:17:41 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50022 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3IWIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaZNd55GLb+kx6ieZRbm=S+8s=izrzew2xH+vkYvdjOpQ@mail.gmail.com>
References: <1378196941-23390-1-git-send-email-sonic.adi@gmail.com>
	<1378196941-23390-2-git-send-email-sonic.adi@gmail.com>
	<CACRpkdaZNd55GLb+kx6ieZRbm=S+8s=izrzew2xH+vkYvdjOpQ@mail.gmail.com>
Date: Mon, 23 Sep 2013 16:17:37 +0800
Message-ID: <CAJxxZ0ORrqjKB0ZHYz=-F2XMDv3TDiQWLwt=jWJTW0JaB2UX8w@mail.gmail.com>
Subject: Re: [PATCH 2/3 v4] blackfin: gpio: Remove none gpio lib code.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Sep 23, 2013 at 3:48 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Sep 3, 2013 at 10:29 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> - Remove non gpio lib code from blackfin architecture.
>> - Limit the lagecy blackfin gpio driver to bf5xx processors only.
>> - Remove unused definition of the pint power functions.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Hi Sonic, I tried to apply this but it doesn't apply cleanly on
> my pinctrl "devel" branch based off v3.12-rc1.
>
> Can you rebase patch 2+3 and resend?

The patch 2 is already in your "devel" branch of kernel v3.12-rc1.
Please apply patch 3 only.

Thanks

Sonic
