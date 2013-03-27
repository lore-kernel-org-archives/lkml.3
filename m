Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3C0NUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:20:21 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:45399 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3C0NUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <1363966065-2478-4-git-send-email-lee.jones@linaro.org>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
	<1363966065-2478-4-git-send-email-lee.jones@linaro.org>
Date: Wed, 27 Mar 2013 14:20:17 +0100
Message-ID: <CACRpkdZovM_uqV3Bb-jxirJfda3PThST805X=htFhzN0pKEJNQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: ux500: Supply a DTS file for the u8540 platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 4:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This is a skeleton DTS file which only enables serial. Just using
> this simple file yields a terminal when booting u8540.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

There is a file for ccu9540.dts so please rename this
to ccu8540.dts for consistence.

(Apart from that it looks all right, a bit messy to see
which files belong to the ST-Ericsson platforms actually,
but I heard the dts folks are working on per-vendor subdirs
so lets wait for that.)

Yours,
Linus Wallei
