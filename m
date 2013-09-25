Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3IYNj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:39:59 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:40592 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3IYNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:39:57 -0400
MIME-Version: 1.0
In-Reply-To: <1380103893-7119-1-git-send-email-joro@8bytes.org>
References: <1380103893-7119-1-git-send-email-joro@8bytes.org>
Date: Wed, 25 Sep 2013 15:39:56 +0200
Message-ID: <CACRpkdZ5G02w9JivgfVW4LvGe35=uCD+ROLC0+iL4HzFaAh9ng@mail.gmail.com>
Subject: Re: [PATCH] arm: mach-integrator: Add stub for pci_v3_early_init()
 for !CONFIG_PCI
From: Linus Walleij <linus.walleij@linaro.org>
To: Joerg Roedel <joro@8bytes.org>, "arm@kernel.org" <arm@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:11 PM, Joerg Roedel <joro@8bytes.org> wrote:

> This fixes a compile error where CONFIG_PCI is disabled:

ARM SoC folks, can you please apply this directly for fixes?

Yours,
Linus Walleij
