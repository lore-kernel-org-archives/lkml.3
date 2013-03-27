Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3C0ILo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:11:44 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51045 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3C0ILm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130305212238.5bf8d974@endymion.delvare>
References: <20130305212238.5bf8d974@endymion.delvare>
Date: Wed, 27 Mar 2013 09:11:41 +0100
Message-ID: <CACRpkdaLkmyqKi95GZPNb3y1mK57DqWPGsAOmw_ZyqcYoUUmKA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] gpio-ich: Check for pin availability at request time
From: Linus Walleij <linus.walleij@linaro.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Peter Tyser <ptyser@xes-inc.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 9:22 PM, Jean Delvare <khali@linux-fr.org> wrote:

> Stop checking for pin availability in direction and get functions.
> These functions can be called repeatedly, so checking every time is
> bad for performance. Now that requesting GPIO pins is no longer
> optional, checking for availability at pin request time is enough.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Peter Tyser <ptyser@xes-inc.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> Changes since v1:
> * Also drop the check from direction functions, as suggested by Peter.

Patch applied.

Thanks!
Linus Walleij
