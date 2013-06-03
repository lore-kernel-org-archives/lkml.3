Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3FCKc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:32:59 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54118 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3FCKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130603100354.GE3370@gmail.com>
References: <000801ce6039$526d9a00$f748ce00$@samsung.com>
	<20130603100354.GE3370@gmail.com>
Date: Mon, 3 Jun 2013 13:32:56 +0300
Message-ID: <CAHp75VfsP=BFz-wVhbGF0LpK84BUtGnDBnVMPq06UtCNJ=u6gw@mail.gmail.com>
Subject: Re: [PATCH V2] mfd: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 1:03 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> The usage of strict_strtoul() is not preferred, because
>> strict_strtoul() is obsolete. Thus, kstrtoul() should be
>> used.
>
> Andy,
>
> Would you mind re-reviewing and providing the appropriate *-by please?

I do not mind. I just did it.

> If you're happy I'll take the patch.

Not fully. But there are few minor things which I believe Jingoo will
easily fix soon.

--
With Best Regards,
Andy Shevchenko
