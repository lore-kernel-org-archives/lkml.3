Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3JILJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:09:14 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59646 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3JILJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <1381217481-17252-1-git-send-email-sonic.adi@gmail.com>
References: <1381217481-17252-1-git-send-email-sonic.adi@gmail.com>
Date: Wed, 9 Oct 2013 13:09:12 +0200
Message-ID: <CACRpkdbgH3grM2MJwdYPpokFzJqsgocNC3-43dteKzQfbEB95w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-adi2: GPIO output value should be set
 after the GPIO interrupt is disabled.
From: Linus Walleij <linus.walleij@linaro.org>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 9:31 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Use BIT macro as well.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Patch applied.

Yours,
Linus Walleij
