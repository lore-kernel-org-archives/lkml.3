Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIYHry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:47:54 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:65000 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaIYHrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:47:52 -0400
MIME-Version: 1.0
In-Reply-To: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
Date: Thu, 25 Sep 2014 09:47:51 +0200
Message-ID: <CACRpkdZCMD4x+wrvTOrrWK-Dy4_rg6bD2xUAA4jtTGTbT1uDag@mail.gmail.com>
Subject: Re: [PATCH 0/5] pinctrl: samsung: Data structure clean-up
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 9:05 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> This series intends to clean up data structures used by pinctrl-samsung driver.
> More specifically, it separates initial compile time constants from data used
> at runtime, allowing unused variant data to be dropped and selected structures
> constified to improve safety.

I like the patch set, tried to apply it but patch 3/5 failed to apply to the
devel branch for pinctrl.

Can you rebase this on my "devel" branch, include Marek's Tested-by
tag and resend, and I'll take it for v3.18.

Yours,
Linus Walleij
