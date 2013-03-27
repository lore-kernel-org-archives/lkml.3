Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3C0Vym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:54:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56027 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3C0Vyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9n7nmyhUcRgPwEyjweZKA+fgi409yEJgK6LmF2Wu6n-g@mail.gmail.com>
References: <CAPgLHd9n7nmyhUcRgPwEyjweZKA+fgi409yEJgK6LmF2Wu6n-g@mail.gmail.com>
Date: Wed, 27 Mar 2013 22:54:40 +0100
Message-ID: <CACRpkdZM-Q8nfwtW_WSA=zK7EMvyo7ubktEpxs-6NQ+jeub9sA@mail.gmail.com>
Subject: Re: [PATCH -next] pinctrl: sirf: using for_each_set_bit to simplify
 the code
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: baohua.song@csr.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
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

Applied with Barry's ACK.

Thanks!
Linus Walleij
