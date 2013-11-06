Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab3KFMKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:10:46 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40694 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab3KFMKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:10:45 -0500
Date: Wed, 6 Nov 2013 12:10:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/13] ARM: ux500: Add DMA config bindings for MSP devices
Message-ID: <20131106121034.GH30901@lee--X1>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
 <1383732985-18928-5-git-send-email-lee.jones@linaro.org>
 <CACRpkdaNy_h60FJYyTmxVFR8V87znP6KtzY48VhA7jHDTziAcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaNy_h60FJYyTmxVFR8V87znP6KtzY48VhA7jHDTziAcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013, Linus Walleij wrote:

> On Wed, Nov 6, 2013 at 11:16 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Usually I would like to apply this separately to my ux500-dt branch.
> 
> While we should keep patches together for bisectability, the dts
> files is something of an exception in my book since they will
> be moved out of the kernel one day. Anyway, do as you please:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Actually, you can take it if you like, as it makes no difference to
this patch-set. Just make sure it's applied before I rip out the MSP
platform data stuff (which I am yet to do).

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
