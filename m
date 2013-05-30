Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589Ab3E3Qmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:42:54 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63164 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935566Ab3E3Qms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <001701ce4a09$a04af0b0$e0e0d210$@samsung.com>
References: <001701ce4a09$a04af0b0$e0e0d210$@samsung.com>
Date: Thu, 30 May 2013 18:42:47 +0200
Message-ID: <CACRpkdYYeGdEBNNrPAnPCD+dtROc8xsfHUMF-B4zspbESbA8cg@mail.gmail.com>
Subject: Re: [PATCH 1/7] gpio: langwell: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:27 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Yours,
Linus Walleij
