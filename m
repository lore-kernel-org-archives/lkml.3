Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965219Ab3E2SFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:05:16 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48874 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964986Ab3E2SFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <1369835757-16371-1-git-send-email-grant.likely@linaro.org>
References: <1369835757-16371-1-git-send-email-grant.likely@linaro.org>
Date: Wed, 29 May 2013 20:05:09 +0200
Message-ID: <CACRpkdatnyCsdJtf0g041k-1_jawfUhS83WSKzw6mWoP+5TKFQ@mail.gmail.com>
Subject: Re: [RFC] arm: Update Booting document for FDT placement and reserved map
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Olivier Martin <olivier.martin@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 3:55 PM, Grant Likely <grant.likely@linaro.org> wrote:

> In this patch I've stated that the initrd doesn't need to be included in
> the reserved map. However, should this be changed? Right now the
> decompressor doesn't actually look at the reserved map when
> decompressing and moving things around. If I'm reading the code
> correctly it is possible that the decompressor will overwrite the initrd
> if it gets placed too close to the kernel.

Maybe people aren't seeing this so much because anyone who
wants to place the ramfs close to the kernel (say because of
memory space constraints) is already using initramfs instead
of initrd?

Yours,
Linus Walleij
