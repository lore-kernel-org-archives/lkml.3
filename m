Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbAYJZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 04:25:59 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51973 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbAYJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 04:25:53 -0500
MIME-Version: 1.0
In-Reply-To: <1421150406-20255-2-git-send-email-johan@kernel.org>
References: <1421150406-20255-1-git-send-email-johan@kernel.org> <1421150406-20255-2-git-send-email-johan@kernel.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 25 Jan 2015 18:25:32 +0900
Message-ID: <CAAVeFuJEVB2NYCEcRrS8oMjhYpon0kp_2nQ9DB5Cp3n1C4tLAA@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio: sysfs: fix gpio-chip device-attribute leak
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 9:00 PM, Johan Hovold <johan@kernel.org> wrote:
> The gpio-chip device attributes were never destroyed when the device was
> removed.
>
> Fix by using device_create_with_groups() to create the device attributes
> of the chip class device.
>
> Note that this also fixes the attribute-creation race with userspace.

... and it also improves code readability.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
