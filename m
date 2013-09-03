Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3ICMLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 08:11:41 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55684 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab3ICMLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 08:11:40 -0400
MIME-Version: 1.0
In-Reply-To: <1378204768-18013-2-git-send-email-treding@nvidia.com>
References: <1378204768-18013-1-git-send-email-treding@nvidia.com>
	<1378204768-18013-2-git-send-email-treding@nvidia.com>
Date: Tue, 3 Sep 2013 14:11:39 +0200
Message-ID: <CACRpkdZth+7FZbcSwTUSug9cCfw8xW3XVbaUv3dEA_cTuFX8Jw@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: Use proper indentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 12:39 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> Indentation should be done using tabs, not a combination of tabs and
> spaces.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Linus,
>
> Feel free to squash this into the commit that introduced these:
>
>         fc9bbfb: gpio: improve error path in gpiolib

This part I actually fixed up properly yesterday, but thanks anyway.

Thanks,
Linus Walleij
