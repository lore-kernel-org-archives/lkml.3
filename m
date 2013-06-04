Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3FDJTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:19:41 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47238 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3FDJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:19:39 -0400
MIME-Version: 1.0
In-Reply-To: <1370012946-7374-1-git-send-email-lee.jones@linaro.org>
References: <1370012946-7374-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 4 Jun 2013 11:19:39 +0200
Message-ID: <CACRpkdZ4EwEgH596VPVvzWYhi054237mZruhEsdZYdwvdPvRyw@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Enable HIGHMEM in the u8540 defconfig
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 5:09 PM, Lee Jones <lee.jones@linaro.org> wrote:

> In order to utilise all of the memory located on ux500 based devices
> we have to enable HIGHMEM. Without it the kernel truncates memory down
> to what's left after the PAGE_OFFSET has been applied, which doesn't
> leave an awful lot, especially if we're running large rootfs' such
> as full Linux desktop distributions or Android.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied, but I renamed the topic arch to u8500
as the defconfig is named as such.

Yours,
Linus Walleij
