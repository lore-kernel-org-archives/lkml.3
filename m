Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3ENLJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:09:08 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:41983 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3ENLJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130514094036.GI3297@gmail.com>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-9-git-send-email-lee.jones@linaro.org>
	<CACRpkdZTU1gv3onjFF4eqxv-o1BQwd48u4gQ9NWqryWoMiKTDQ@mail.gmail.com>
	<20130514084756.GE3297@gmail.com>
	<CACRpkdbhHnrN3MGufubyYLNXdcCgZ2OpQ4a2CG6bwPJk88DZRg@mail.gmail.com>
	<20130514094036.GI3297@gmail.com>
Date: Tue, 14 May 2013 13:09:05 +0200
Message-ID: <CACRpkda5v5BOidCNEnGK5TFyvbBd0R85Enu5hdhBzdjbn45BNw@mail.gmail.com>
Subject: Re: [PATCH 8/9] pinctrl: abx500: Rejiggle platform data and DT initialisation
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

On Tue, May 14, 2013 at 11:40 AM, Lee Jones <lee.jones@linaro.org> wrote:

>> I'm happy to apply it but what do I write in the commit message?
>
> Platform Data is invariably populated for this driver, even when
> booting with Device Tree. Thus the Device Tree probing code encased
> within the first check for Platform Data will never executed, causing
> the driver to fail when DT is enabled.
>
> This patch fixes the aforementioned regression by rejigging the
> probe() semantics to attempt to extract a platform ID from Device Tree
> if one can not be sourced from platform data.

Thanks!
Copy/pasted into commit message and applied to fixes.

Yours,
Linus Walleij
