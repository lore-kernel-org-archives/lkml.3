Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbaDVVPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:15:19 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:46854 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaDVVPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <1397564503-5175-1-git-send-email-vincent.donnefort@seagate.com>
References: <20140415084056.GA26578@ks3318809.kimsufi.com>
	<1397564503-5175-1-git-send-email-vincent.donnefort@seagate.com>
Date: Tue, 22 Apr 2014 23:15:15 +0200
Message-ID: <CACRpkdYUtiW78=3tiyGBb31THHNYHjm55wLPFfUqnX1nyJnnqA@mail.gmail.com>
Subject: Re: [PATCH] gpio: ich: set regs and reglen for i3100 and ich6 chipset
From: Linus Walleij <linus.walleij@linaro.org>
To: Vincent Donnefort <vdonnefort@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ptyser@xes-inc.com" <ptyser@xes-inc.com>, eparis@redhat.com,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 2:21 PM, Vincent Donnefort <vdonnefort@gmail.com> wrote:

> From: Vincent Donnefort <vdonnefort@gmail.com>
>
> This patch fixes kernel NULL pointer BUG introduced by the following commit:
> b667cf488aa9476b0ab64acd91f2a96f188cfd21
> gpio: ich: Add support for multiple register addresses.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>

Patch applied for fixes with Eric's tested-by tag.

Thanks!
Linus Walleij
