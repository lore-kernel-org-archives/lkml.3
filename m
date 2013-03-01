Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3CAAyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:54:22 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:39010 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3CAAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:54:21 -0500
MIME-Version: 1.0
In-Reply-To: <009401ce13c9$c01f6400$405e2c00$%han@samsung.com>
References: <009401ce13c9$c01f6400$405e2c00$%han@samsung.com>
Date: Fri, 1 Mar 2013 01:54:21 +0100
Message-ID: <CACRpkdZBbuxogFy7NXiPnf4FR_eO2KJVck4C80dZZXuAZTsQzQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: core: use devres_release() instead of devres_destroy()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>, Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 3:34 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> devres_release() can simplify the code, because devres_release()
> will call the destructor for the resource as well as freeing
> the devres data.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Hm, Stephen, you OK with this?

Yours,
Linus Walleij
