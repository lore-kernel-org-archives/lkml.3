Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3LMBwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:52:07 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:33178 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3LMBwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:52:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Walleij <linus.walleij@linaro.org>,
        "Lee Jones" <lee.jones@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CACRpkdZ+kg8VEMZ6gy6CG=YK0Ycj-Ud-UuRohzKgE4UW_VUMjg@mail.gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
 <1379506478-16625-23-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ+kg8VEMZ6gy6CG=YK0Ycj-Ud-UuRohzKgE4UW_VUMjg@mail.gmail.com>
Message-ID: <20131213015158.11981.27135@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 22/41] clk: ux500: Copy u8500_clk_init() ready for DT enablement
Date: Thu, 12 Dec 2013 17:51:58 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Walleij (2013-09-20 13:59:46)
> On Wed, Sep 18, 2013 at 2:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Here we're using the old clock initialisation function as a template.
> > It's necessary to remove all of the clk_register_clkdev() calls as
> > they don't make sense when booting with Device Tree.
> >
> > Cc: Mike Turquette <mturquette@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> I *really* like the looks of this! Mike can we have your ACK on this?

Acked-by: Mike Turquette <mturquette@linaro.org>

> 
> Yours,
> Linus Walleij
