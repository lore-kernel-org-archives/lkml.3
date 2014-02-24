Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaBXJ4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:56:20 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:59478 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBXJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:56:19 -0500
MIME-Version: 1.0
In-Reply-To: <1392037257-20607-1-git-send-email-geert+renesas@linux-m68k.org>
References: <1392037257-20607-1-git-send-email-geert+renesas@linux-m68k.org>
Date: Mon, 24 Feb 2014 10:56:18 +0100
Message-ID: <CACRpkdbT3SX1J6zs0HhPVnjjRXeB8Um0nHsV4UgD_Qakkw=Jxw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: sh-pfc: r8a7790: Add QSPI pin groups
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 2:00 PM, Geert Uytterhoeven
<geert+renesas@linux-m68k.org> wrote:

> A QSPI function set consists of 3 groups:
>   - qspi_ctrl (2 control wires)
>   - qspi_data2 (2 data wires, for Single/Dual SPI)
>   - qspi_data4 (4 data wires, for Quad SPI)
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
> v2: Insert line at correct position in pinmux_functions[]

Patch applied, sorry for the delay.

Yours,
Linus Walleij
