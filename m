Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3ENMFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:05:04 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:63677 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3ENMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:05:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-av2Yg44ARcSGr_zOajO-U611y3N4_Sn7J5Z+=OfVFcg@mail.gmail.com>
References: <CAPgLHd-av2Yg44ARcSGr_zOajO-U611y3N4_Sn7J5Z+=OfVFcg@mail.gmail.com>
Date: Tue, 14 May 2013 14:05:01 +0200
Message-ID: <CACRpkdZ7i7EBuwqfGZ2Kby6DjTU3vcp89OH+wKx7YSpS4y9DdQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: single: fix error return code in pcs_parse_one_pinctrl_entry()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 2:06 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Introduced by commit 9dddb4df90d136429b6d6ddefceb49a9b93f6cd1
> (pinctrl: single: support generic pinconf)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, patch applied to fixes with Haojians ACK.

Yours,
Linus Walleij
