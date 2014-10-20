Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaJTMhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:37:07 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:48389 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaJTMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <1413733260.6272.1.camel@phoenix>
References: <1413733260.6272.1.camel@phoenix>
Date: Mon, 20 Oct 2014 14:37:04 +0200
Message-ID: <CACRpkdaTcxngj6MLGHUyx-AbB3o4iV2dtsmCCVHwacuDp=0D3A@mail.gmail.com>
Subject: Re: [PATCH] soc: versatile: Add terminating entry for realview_soc_of_match
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 5:41 PM, Axel Lin <axel.lin@ingics.com> wrote:

> The of_device_id table is supposed to be zero-terminated.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Arnd are you merging this directly into ARM SoC?

Yours,
Linus Walleij
