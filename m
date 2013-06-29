Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3F2Xhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:37:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49698 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3F2Xhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:37:31 -0400
MIME-Version: 1.0
In-Reply-To: <1372337935-28772-1-git-send-email-wangyijing@huawei.com>
References: <1372337935-28772-1-git-send-email-wangyijing@huawei.com>
Date: Sun, 30 Jun 2013 01:37:31 +0200
Message-ID: <CACRpkdZ8YFNwe09vkPTnvjhsuUxbyubnTNX_CaMwiWZA5iphbQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] Gpio/trivial: replace numeric with standard PM state macros
From: Linus Walleij <linus.walleij@linaro.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Michael Buesch <m@bues.ch>, Grant Likely <grant.likely@linaro.org>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 2:58 PM, Yijing Wang <wangyijing@huawei.com> wrote:

> Use standard PM state macros PCI_Dx instead of numeric 0/1/2..
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Michael Buesch <m@bues.ch>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: linux-kernel@vger.kernel.org

Patch applied.

Yours,
Linus Walleij
