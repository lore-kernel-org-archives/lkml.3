Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbbAFId3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:33:29 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34853 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbbAFIdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:33:25 -0500
MIME-Version: 1.0
In-Reply-To: <1419241498-3290-1-git-send-email-lftan@altera.com>
References: <1419241498-3290-1-git-send-email-lftan@altera.com>
Date: Tue, 6 Jan 2015 16:33:23 +0800
Message-ID: <CAFiDJ58yQcyYDiL9PaD-fP23dpjcLEibw9cDYKW7g2Sb9oYgQw@mail.gmail.com>
Subject: Re: [PATCH v2] mailbox: Add Altera mailbox driver
From: Ley Foon Tan <lftan.linux@gmail.com>
To: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ley Foon Tan <lftan@altera.com>, Ley Foon Tan <lftan.linux@gmail.com>,
        Suman Anna <s-anna@ti.com>, devicetree@vger.kernel.org,
        Dinh Nguyen <dinh.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 5:44 PM, Ley Foon Tan <lftan@altera.com> wrote:
> The Altera mailbox allows for interprocessor communication. It supports
> only one channel and work as either sender or receiver.
>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>
> ---
> v2:
> Resolved comment from Dinh and Suman.
> - Alphabetize the headers.
> - Removed WARN_ON() checking
> - Use devm_kzalloc to allocate struct mbox_chan
> - Change __raw_readl/__raw_writel to readl/writel
> - Check interrupt mode before enable interrupt
> - Change to use module_platform_driver()
> - Remove platform_set_drvdata(pdev, NULL);
> - Fix "Alignment should match open parenthesis" warning
> - Update MAINTAINERS file
> ---

Any further feedback for this v2 patch?

Thanks.

Regards.
