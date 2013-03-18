Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab3CRCfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:35:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36926 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3CRCfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ_AvahCLkPhbdB7Dk-qaxpAEN-B9qCMsJWBKi8+GtuOQ@mail.gmail.com>
References: <CAPgLHd9n7nmyhUcRgPwEyjweZKA+fgi409yEJgK6LmF2Wu6n-g@mail.gmail.com>
 <CACRpkdZ_AvahCLkPhbdB7Dk-qaxpAEN-B9qCMsJWBKi8+GtuOQ@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 18 Mar 2013 10:34:43 +0800
Message-ID: <CAGsJ_4za5S4YoCWDFz1uaVkTM-yghbufcEhv3g+DBTr1pn+vJA@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: sirf: using for_each_set_bit to simplify
 the code
To: Linus Walleij <linus.walleij@linaro.org>, Wei Yongjun <weiyj.lk@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        linux-arm-kernel@lists.infradead.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/14 Linus Walleij <linus.walleij@linaro.org>
>
> On Mon, Mar 11, 2013 at 3:23 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Using for_each_set_bit() to simplify the code.
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Barry, can I have your ACK on this?

yes. acked. thanks Yongjun, Linus.

>
> Yours,
> Linus Walleij

-barry
