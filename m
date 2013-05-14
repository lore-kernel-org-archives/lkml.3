Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3ENL7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:59:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51203 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3ENL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:59:04 -0400
MIME-Version: 1.0
In-Reply-To: <002401ce4a0c$12a10ad0$37e32070$@samsung.com>
References: <002401ce4a0c$12a10ad0$37e32070$@samsung.com>
Date: Tue, 14 May 2013 13:59:03 +0200
Message-ID: <CACRpkdZAMq-suW44o_n4ptK8YKjmO+JOUks75R-b7q-S4EC1BQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: u300: remove unnecessary platform_set_drvdata()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:44 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.

Thanks!
Linus Walleij
