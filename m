Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3HPNGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:06:16 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38006 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3HPNGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <1374871193-403-1-git-send-email-achew@nvidia.com>
References: <1374871193-403-1-git-send-email-achew@nvidia.com>
Date: Fri, 16 Aug 2013 15:06:08 +0200
Message-ID: <CACRpkdbtqOpJq15roU7pp0DOeJkJm8YDQXW6jeR1zKCkJDw5Aw@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: palmas: Fix misreported GPIO out value
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Chew <achew@nvidia.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 10:39 PM, Andrew Chew <achew@nvidia.com> wrote:

> It seems that the value read back from the PALMAS_GPIO_DATA_IN register
> isn't valid if the GPIO direction is out.  When that's the case, we can
> read back the PALMAS_GPIO_DATA_OUT register to get the proper output value.
>
> Change-Id: Iaf877e538cfdb37a6759c45ec3c6e4ee31078709

Very interesting that you use gerrit, but the kernel community does not
want this.

> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> V2: Fixed a warning from using test_bit with an int instead of long.  Keeping
>     the int and just masking that bit in the raw now.

Applied with change-id stripped and Laxman's ACK.

Yours,
Linus Walleij
