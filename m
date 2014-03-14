Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaCNJRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:17:54 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39534 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbaCNJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:17:52 -0400
MIME-Version: 1.0
In-Reply-To: <1394520729-1587-1-git-send-email-acourbot@nvidia.com>
References: <1394520729-1587-1-git-send-email-acourbot@nvidia.com>
Date: Fri, 14 Mar 2014 10:17:52 +0100
Message-ID: <CACRpkdYD78v1k3=1J87EdbefirsywFhgQP=hgjiffhLzgJ+N2Q@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: clamp returned values to the boolean range
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 7:52 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> This patch makes the internal _gpiod_get_raw_value() function return a
> bool, effectively clamping the GPIO value to the boolean range no
> matter what the driver does.

This looks good, patch applied!

Yours,
Linus Walleij
