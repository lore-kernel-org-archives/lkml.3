Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaAWILY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:11:24 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:41502 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaAWILW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <1390339396-3479-53-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-53-git-send-email-paul.gortmaker@windriver.com>
Date: Thu, 23 Jan 2014 09:11:22 +0100
Message-ID: <CACRpkdaEabRiwPBWHb6cDYMe-vcCXLYN7OQFx7vYaf55cWiYvw@mail.gmail.com>
Subject: Re: [PATCH 52/73] drivers/pinctrl: delete non-required instances of
 include <linux/init.h>
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:22 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Patch applied for v3.15.

Yours,
Linus Walleij
