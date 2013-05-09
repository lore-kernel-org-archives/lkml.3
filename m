Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3EIWHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:07:30 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:44326 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3EIWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <1368133099-16997-1-git-send-email-olof@lixom.net>
References: <1368133099-16997-1-git-send-email-olof@lixom.net>
Date: Thu, 9 May 2013 15:07:25 -0700
X-Google-Sender-Auth: h8jLcefasZaCwfF0fwMm8tOp7fk
Message-ID: <CAD=FV=VMCLk0h0XxJv1Q3EkpottVkpwKEa87McmmipdJA7TN+A@mail.gmail.com>
Subject: Re: [PATCH] ARM: exynos: defconfig update
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof,

On Thu, May 9, 2013 at 1:58 PM, Olof Johansson <olof@lixom.net> wrote:
> +CONFIG_ZBOOT_ROM_TEXT=0x0
> +CONFIG_ZBOOT_ROM_BSS=0x0

Probably these aren't needed, but don't hurt since the default is 0.
This seems to pop up a lot since there are lots of legacy configs that
have 0x0 here.

Either with or without that fixup, this looks reasonable to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
