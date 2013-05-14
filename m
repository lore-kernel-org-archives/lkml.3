Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3ENLzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:55:45 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46971 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3ENLzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:55:43 -0400
MIME-Version: 1.0
In-Reply-To: <001e01ce4a0b$6b8e32e0$42aa98a0$@samsung.com>
References: <001e01ce4a0b$6b8e32e0$42aa98a0$@samsung.com>
Date: Tue, 14 May 2013 13:55:43 +0200
Message-ID: <CACRpkdbbKsai303o1nJeV4Z16thCL-PL=gTwtnZOdE8yHmuC4Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: coh901: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:40 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks!
Linus Walleij
