Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaBYJWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:22:54 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37267 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaBYJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:22:52 -0500
MIME-Version: 1.0
In-Reply-To: <1392907779-22053-2-git-send-email-geert@linux-m68k.org>
References: <1392907779-22053-1-git-send-email-geert@linux-m68k.org>
	<1392907779-22053-2-git-send-email-geert@linux-m68k.org>
Date: Tue, 25 Feb 2014 10:22:51 +0100
Message-ID: <CACRpkdaMmJg_z_sb4bxrPhXM9=Q=n80XJO55td6-R1eG68q1yQ@mail.gmail.com>
Subject: Re: [PATCH 01/11] ARM: shmobile: r8a7791 dtsi: Fix typo in msiof2
 clock output name
From: Linus Walleij <linus.walleij@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 3:49 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:

> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>
> Introduced in commit cded80f869aef94853e056ab9c21e305b0c26138 ("ARM:
> shmobile: r8a7791: Add MSIOF clocks in device tree").
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Patch applied with Laurent's ACK.

Yours,
Linus Walleij
