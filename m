Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372Ab3DCUrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:47:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40462 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762735Ab3DCUrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:47:37 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-9-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-9-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:47:36 +0200
Message-ID: <CACRpkdaRfBFMO+XnJVq9ccxsqw3+RS+OCPuF8ivrrRu=OxuJEQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] mfd: db8500-prcmu: Support platform dependant device selection
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The main aim for this cycle is to have the u8540 booting to a
> console. However, the u8540 doesn't support all of the u8500
> platform devices yet. After this stage is complete we can then
> fill in the inadequacies, such as specific clock support at a
> later date. To achieve this we're placing devices supported by
> all platforms into a common device structure and the remaining
> ones into a platform specific one.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

This should also go through the MFD tree.

Yours,
Linus Walleij
