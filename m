Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab3HPPPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:15:24 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:59688 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HPPPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:15:22 -0400
MIME-Version: 1.0
In-Reply-To: <1376378216-18473-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376378216-18473-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Fri, 16 Aug 2013 17:15:21 +0200
Message-ID: <CACRpkdanzU9gjKQ7apUVQcBbROBcTgjA9mOfS6C8+4oAD1t_yQ@mail.gmail.com>
Subject: Re: [PATCH 1/5 v2] drivers/gpio/gpio-omap.c: convert comma to semicolon
From: Linus Walleij <linus.walleij@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        kernel-janitors@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 9:16 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Replace a comma between expression statements by a semicolon.  This changes
> the semantics of the code, but given the current indentation appears to be
> what is intended.

Aha there is the right patch, sorry for the noise.

Patch applied with Kevin's ACK.

Yours,
Linus Walleij
