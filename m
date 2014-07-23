Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbaGWPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:38:20 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43188 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbaGWPiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <1406013463-19218-3-git-send-email-acourbot@nvidia.com>
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
	<1406013463-19218-3-git-send-email-acourbot@nvidia.com>
Date: Wed, 23 Jul 2014 17:38:15 +0200
Message-ID: <CACRpkdZj4VSot1pABvo=UT7Qq7CZJ1HPhbJKc29nU8zhOLuKug@mail.gmail.com>
Subject: Re: [PATCH 2/5] gpio: simplify gpiochip_export()
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 9:17 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> For some reason gpiochip_export() would invalidate all the descriptors
> of a chip if exporting it to sysfs failed. This does not appear as
> necessary. Remove that part of the code.
>
> While we are at it, add a note about the non-safety of temporarily
> releasing a spinlock in the middle of the loop that protects its
> iterator, and explain why this is done.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Patch applied.

Yours,
Linus Walleij
