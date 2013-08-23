Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3HWN0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:26:08 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49027 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3HWN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:26:07 -0400
MIME-Version: 1.0
In-Reply-To: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
Date: Fri, 23 Aug 2013 15:26:06 +0200
Message-ID: <CACRpkda8qaNa09OLzsrK2KXzaFx-nwWr0pJpehN5qWtuKTORsA@mail.gmail.com>
Subject: Re: [PATCH 0/40] ARM: ux500: Convert to Device Tree only platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 2:23 PM, Lee Jones <lee.jones@linaro.org> wrote:

> I started by taking out simple, unimportant pieces, then finalised by
> removing the critical booting components required for booting with
> ATAGs. After this patch-set the ux500 will only boot with Device Tree
> enabled. DT boot appears to be unaffected by the work, tested on
> Snowball.

Overall a very nice pice-by-piece approach, thanks!

We need to CLK DT stuff sorted out and applied first though.

I think we can just go ahead and start applying first the clk DT
and then this as a first take for v3.13 after the merge window.
(It's way too late for v3.12.)

Yours,
Linus Walleij
