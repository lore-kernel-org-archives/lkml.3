Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3FRHl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:41:58 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58835 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3FRHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd8SP8Cwiukgpwhfe0Cea248k5cE9P=SNG6Kgt=7z=4JLg@mail.gmail.com>
References: <CAPgLHd8SP8Cwiukgpwhfe0Cea248k5cE9P=SNG6Kgt=7z=4JLg@mail.gmail.com>
Date: Tue, 18 Jun 2013 09:41:57 +0200
Message-ID: <CACRpkdaRO5-BWE56aHayFi0j14vibaan_hKikBOsbw4+cpzo-A@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: core: fix missing unlock on error in pinctrl_find_gpio_range_from_pin()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 6:24 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing unlock before return from function pinctrl_find_gpio_range_from_pin()
> in the error handling case.
>
> Introduced by commit 2ff3477efd7086544b9e298fc63afab0645921b4.
> (pinctrl: add pin list based GPIO ranges)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

*Very* nice patch there Wei, applied of course.

Thanks a lot!
Linus Walleij
