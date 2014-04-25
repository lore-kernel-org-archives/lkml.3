Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaDYHwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:52:55 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47998 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaDYHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:52:53 -0400
MIME-Version: 1.0
In-Reply-To: <1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
References: <1398266889-17489-1-git-send-email-thierry.reding@gmail.com>
	<1398266889-17489-2-git-send-email-thierry.reding@gmail.com>
Date: Fri, 25 Apr 2014 09:52:52 +0200
Message-ID: <CACRpkdbF3N5bFY1sFkabDHO7J0F8sb1uU0xL+mjkuF-z7VocMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: of: Allow -gpio suffix for property names
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
> Many bindings use the -gpio suffix in property names. Support this in
> addition to the -gpios suffix when requesting GPIOs using the new
> descriptor-based API.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

It appears this can save quite a lot of code in drivers, work that
I trust Thierry to persue based on this to some extent so patch is
tentatively applied unless something comes up.

Yours,
Linus Walleij
