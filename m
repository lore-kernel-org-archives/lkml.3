Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaHHNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:25:01 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53808 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbaHHNY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:24:58 -0400
MIME-Version: 1.0
In-Reply-To: <b409bc59d95336f26b13ce37a5ae3d06417aa814.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
	<b409bc59d95336f26b13ce37a5ae3d06417aa814.1406691397.git.joe@perches.com>
Date: Fri, 8 Aug 2014 15:24:57 +0200
Message-ID: <CACRpkdbLaGzqU5mH0fq8dmHUic9SoVk4JoLux=COO-z3cvPT3w@mail.gmail.com>
Subject: Re: [PATCH 6/6] MAINTAINERS: Update nomadik patterns
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Rubini <rubini@unipv.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 5:38 AM, Joe Perches <joe@perches.com> wrote:

> commit 3a19805920f1 ("pinctrl: nomadik: move all Nomadik drivers to subdir")
> move the files, update the patterns
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Linus Walleij <linus.walleij@linaro.org>
> cc: Alessandro Rubini <rubini@unipv.it>

I saw Andrew quickly picked this up, but IIRC he prefers to have
them merged through the subsystem trees, so applied to the pin
control tree.

Yours,
Linus Walleij
