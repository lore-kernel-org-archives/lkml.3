Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaAQXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 18:13:32 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:44015 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaAQXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 18:13:28 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYVLF+CNcAc8=MiSRJJMBWy3LriDw271Bx=gjuuzdOatA@mail.gmail.com>
References: <1389912312-16285-1-git-send-email-linus.walleij@linaro.org>
	<52D989C2.6030603@broadcom.com>
	<CACRpkdYVLF+CNcAc8=MiSRJJMBWy3LriDw271Bx=gjuuzdOatA@mail.gmail.com>
Date: Sat, 18 Jan 2014 00:13:28 +0100
Message-ID: <CACRpkdZ9OBkKaLuQbc1oz0uPePBtqttGyOwV02iFWZ+CT1gwnw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: capri: add dependency on OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Christian Daudt <bcm@fixthebug.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 12:12 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Fri, Jan 17, 2014 at 8:51 PM, Sherman Yin <syin@broadcom.com> wrote:
>
>> Thanks for the fix, Linus.  While we're visiting this config, should we add
>> "depends on MACH_BCM_MOBILE" as well?
>
> No, it's nice to get the compile coverage.

But maybe you can experiment with that special option that only
turns on the driver on other platforms to do compile test.

Yours,
Linus Walleij
