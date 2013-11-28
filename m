Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab3K1Od7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:33:59 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49608 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab3K1Od6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:33:58 -0500
MIME-Version: 1.0
In-Reply-To: <1385186152-29188-1-git-send-email-acourbot@nvidia.com>
References: <1385186152-29188-1-git-send-email-acourbot@nvidia.com>
Date: Thu, 28 Nov 2013 15:33:57 +0100
Message-ID: <CACRpkdbJ9ogqjohaHOU=3c4R--jh7nhGB9oFGheP+6LX8T5u7A@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: fix lookup of platform-mapped GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 6:55 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> A typo resulted in GPIO lookup failing unconditionally.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Stephen Warren <swarren@wwwdotorg.org>

Patch applied for fixes with Mika's ACK.

Yours,
Linus Walleij
