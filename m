Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaICIpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:45:20 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36435 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaICIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <1409159852-7249-12-git-send-email-mathieu.poirier@linaro.org>
References: <1409159852-7249-1-git-send-email-mathieu.poirier@linaro.org>
	<1409159852-7249-12-git-send-email-mathieu.poirier@linaro.org>
Date: Wed, 3 Sep 2014 10:45:16 +0200
Message-ID: <CACRpkdZerhSgrGimebPY-iY3aV40wRyf-DjsSS+iMOgOj1k_Pw@mail.gmail.com>
Subject: Re: [PATCH 11/11 v5] ARM: removing support for etb/etm in "arch/arm/kernel/"
From: Linus Walleij <linus.walleij@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>, Tony.Armitstead@arm.com,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:17 PM,  <mathieu.poirier@linaro.org> wrote:

> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>
> Removing minimal support for etb/etm to favour an implentation
> that is more flexible, extensible and capable of handling more
> platforms.
>
> Also removing the only client of the old driver.  That code can
> easily be replaced by entries for etb/etm in the device tree.
>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

The new driver is clearly better.

Yours,
Linus Walleij
