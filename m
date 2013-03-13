Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab3CMRuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:50:12 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:33824 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab3CMRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:50:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9n7nmyhUcRgPwEyjweZKA+fgi409yEJgK6LmF2Wu6n-g@mail.gmail.com>
References: <CAPgLHd9n7nmyhUcRgPwEyjweZKA+fgi409yEJgK6LmF2Wu6n-g@mail.gmail.com>
Date: Wed, 13 Mar 2013 18:50:10 +0100
Message-ID: <CACRpkdZ_AvahCLkPhbdB7Dk-qaxpAEN-B9qCMsJWBKi8+GtuOQ@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: sirf: using for_each_set_bit to simplify
 the code
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, Barry Song <Baohua.Song@csr.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 3:23 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using for_each_set_bit() to simplify the code.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Barry, can I have your ACK on this?

Yours,
Linus Walleij
