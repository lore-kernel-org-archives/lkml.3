Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaJEK3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 06:29:20 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49127 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaJEK3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 06:29:16 -0400
MIME-Version: 1.0
In-Reply-To: <1412160393-5848-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412160393-5848-1-git-send-email-pramod.gurav@smartplayin.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 5 Oct 2014 19:28:55 +0900
Message-ID: <CAAVeFuJsWJ5Yu8+cSS4VSpQyqFzxO57QCXdP-ZjoY_-RcuPC-A@mail.gmail.com>
Subject: Re: [PATCH] gpio: Switch to using managed resources with devm_
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 7:46 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
> This change switches to devm_request_region to request region
> and hence simplifies the module unload and does away with
> release_region in remove function.

Your subject line should probably start with "gpio: cs5535:"

Otherwise,

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
