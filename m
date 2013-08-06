Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3HFKPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:15:30 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64101 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab3HFKP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9cUJtF7WXmY4Sy+53MxjKJRe8RVNNtbfdYLzh6OwbNzg@mail.gmail.com>
References: <CAPgLHd9cUJtF7WXmY4Sy+53MxjKJRe8RVNNtbfdYLzh6OwbNzg@mail.gmail.com>
Date: Tue, 6 Aug 2013 12:15:28 +0200
Message-ID: <CACRpkdZ9VBjPVOB9t4E6MJ80m_Mb78Fvp5sPk2Y0hOTQqu1wBA@mail.gmail.com>
Subject: Re: [PATCH] ARM: u300: fix return value check in __u300_init_boardpower()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 3:51 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function syscon_node_to_regmap() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value check should
> be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.

Yours,
Linus Walleij
