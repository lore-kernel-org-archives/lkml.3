Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3JRJmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:42:13 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55437 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3JRJmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:42:11 -0400
MIME-Version: 1.0
In-Reply-To: <20131016090819.GC19112@lee--X1>
References: <1381871475-21543-1-git-send-email-linus.walleij@linaro.org>
	<20131016090819.GC19112@lee--X1>
Date: Fri, 18 Oct 2013 11:42:11 +0200
Message-ID: <CACRpkdaHFsjZBYhMGBdWhPTQErZXjai-BKXQ=Jvfwn0-AdLQ_A@mail.gmail.com>
Subject: Re: [PATCH 1/5] mfd: tc3589x: add device tree bindings
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:08 AM, Lee Jones <lee.jones@linaro.org> wrote:

> 1. MFD patches have the following syntax:
>   mfd: <device>[-sub]: <Description> /* Note the uppercase 'D' */

Sure fixed this.

> 2. The binding document is normally attached to the patch which
> applies the bindings, unless we've stopped doing that now.

This is a bit of special case since we already have "sort-of"
device tree support on this driver.
commit a435ae1d51e2f18414f2a87219fdbe068231e692
added some device tree support but no bindings.

>> +
>> +Example:
>> +
>
> 3. You left off the example?

OMG I'll fix.

Yours,
Linus Walleij
