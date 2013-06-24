Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3FXM0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:26:25 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38980 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3FXM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:26:24 -0400
MIME-Version: 1.0
In-Reply-To: <1371948514.9509.1.camel@phoenix>
References: <1371948514.9509.1.camel@phoenix>
Date: Mon, 24 Jun 2013 14:26:24 +0200
Message-ID: <CACRpkdY3HiFjwHBOgEVeb4XWzwBGn7ju3=icMkQCrPPp5J6_wQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: Add missing irq_gc_unlock() call
 before return error
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 2:48 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Excellent catch (as always).
Patch applied with Heiko's ACK.

Yours,
Linus Walleij
