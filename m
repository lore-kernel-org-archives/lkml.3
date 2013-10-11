Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3JKK5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:57:39 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43497 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3JKK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <1380638143-20040-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1380638143-20040-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 11 Oct 2013 12:57:37 +0200
Message-ID: <CACRpkda=C3+pkVsVbZAkasxyWGedNsb7oAKTt4ApnJ4Q+k9BCw@mail.gmail.com>
Subject: Re: [PATCH] gpio/lynxpoint: check if the interrupt is enabled in IRQ handler
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 4:35 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Checking LP_INT_STAT is not enough in the interrupt handler because its
> contents get updated regardless of whether the pin has interrupt enabled or
> not. This causes the driver to loop forever for GPIOs that are pulled up.
>
> Fix this by checking the interrupt enable bit for the pin as well.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied for fixes with Mathias ACK.

Should this be tagged for -stable as well?

Yours,
Linus Walleij
