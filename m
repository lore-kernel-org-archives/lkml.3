Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaDXMoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:44:13 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33004 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaDXMnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
Date: Thu, 24 Apr 2014 14:43:21 +0200
Message-ID: <CACRpkdZZfxTV9ODrH6Z5xGFf+cUcKGzj+E-gZaZnV8Ho1adO8Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: of: Remove unneeded dummy function
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 5:28 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
>
> of_find_gpio() is always called under an IS_ENABLED(CONFIG_OF), so the
> dummy implementation provided for !OF configurations is not needed.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Patch applied.

Yours,
Linus Walleij
