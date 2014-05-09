Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaEILkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:40:53 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34902 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbaEILkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <1398800520-18135-1-git-send-email-alchark@gmail.com>
References: <1398800520-18135-1-git-send-email-alchark@gmail.com>
Date: Fri, 9 May 2014 13:40:51 +0200
Message-ID: <CACRpkdbJGWbTJQBJqs-T6c29JciKofMkWoSU=zYW2BOEP-VEJA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: vt8500: Ensure value reg is updated when setting direction
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 9:42 PM, Alexey Charkov <alchark@gmail.com> wrote:

> Current code only touches the direction register when setting direction
> to output, which breaks logic like
>
> echo high > /sys/class/gpio/gpio0/direction
>
> which is expected to also set the value. This patch also adds a call
> to update the value register when setting direction to output.
>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

Patch applied for fixes with Tony's ACK.

Yours,
Linus Walleij
