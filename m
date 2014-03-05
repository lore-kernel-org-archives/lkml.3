Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaCEB6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:58:30 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43274 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaCEB62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:58:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140226101026.16737.30404.sendpatchset@w520>
References: <20140226101026.16737.30404.sendpatchset@w520>
Date: Wed, 5 Mar 2014 09:58:27 +0800
Message-ID: <CACRpkdYK_ej8f_+EUsgc_X-iJ-Ynp40az59i6D1z9f4k31v+rQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sh-pfc: r8a7791: SD1_CLK fix
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Valentine <valentine.barshak@cogentembedded.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 6:10 PM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Fix the SD1_CLK handling for r8a7791. Without this patch
> it is impossible to request all pins needed for SDHI1 on
> the Koelsch board.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, applied for fixes.

Yours,
Linus Walleij
