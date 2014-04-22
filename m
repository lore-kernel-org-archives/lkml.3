Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaDVNES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:04:18 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42956 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaDVNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <1397325554-1439-1-git-send-email-colin.king@canonical.com>
References: <1397325554-1439-1-git-send-email-colin.king@canonical.com>
Date: Tue, 22 Apr 2014 15:04:16 +0200
Message-ID: <CACRpkdYq9q=WinNb8+R15KjbpAji_wK_Dhe5qPXO-qbu7QN3BQ@mail.gmail.com>
Subject: Re: [PATCH] clk: versatile: free icst on error return
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin King <colin.king@canonical.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 7:59 PM, Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
>
> commit a183da63 introduced a new error return path that does
> not kfree icst if the kmemdup of desc->params fails.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
