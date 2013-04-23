Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3DWKmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:42:15 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:60368 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3DWKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130404072907.GB3004@gmail.com>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdafSvT5Xb=7sqnkRHcc4UKkVzr8jzThMgWn6459RDmKGw@mail.gmail.com>
	<20130404072907.GB3004@gmail.com>
Date: Tue, 23 Apr 2013 12:42:12 +0200
Message-ID: <CACRpkdZL=j+gj8dFbWMfYiNFisjQj23HKiMeZXk+OAfcp=j4zg@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Supply a DTS file for the u8540 platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 9:29 AM, Lee Jones <lee.jones@linaro.org> wrote:

> This is a skeleton DTS file which only enables serial. Just using
> this simple file yields a terminal when booting u8540.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I've queued this patch for v3.11.

Yours,
Linus Walleij
