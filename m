Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3KZXav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:30:51 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41823 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3KZXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:30:48 -0500
MIME-Version: 1.0
In-Reply-To: <1385403450-18018-1-git-send-email-sre@debian.org>
References: <1385403450-18018-1-git-send-email-sre@debian.org>
Date: Wed, 27 Nov 2013 00:30:48 +0100
Message-ID: <CACRpkdYSXDAwS1mxLtUL7qpHkfD1efo1QF0OMKS-YHKM-689Kw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add HSI subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 7:17 PM, Sebastian Reichel <sre@debian.org> wrote:

> This adds me as maintainer for the HSI subsystem and
> Carlos Chinea (original author) to the CREDITS file.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>

(Good idea)

> +HSI SUBSYSTEM
> +M:     Sebastian Reichel <sre@debian.org>
> +S:     Maintained
> +F:     Documentation/hsi/
> +F:     drivers/hsi/
> +F:     include/linux/hsi/
> +F:     include/uapi/linux/hsi/

Don't add directories that do not exist (yet).

Yours,
Linus Walleij
