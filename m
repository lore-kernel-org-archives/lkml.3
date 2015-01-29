Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761704AbbA2Ja2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:30:28 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48397 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761241AbbA2JaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <1421872537-18587-1-git-send-email-o.schinagl@ultimaker.com>
References: <1421872537-18587-1-git-send-email-o.schinagl@ultimaker.com>
Date: Thu, 29 Jan 2015 10:30:23 +0100
Message-ID: <CACRpkdaRedRJdn_Jj584=zrNdePrNr2bQLHSsyNiMPHJyVkGdQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: correctly use const char * const
From: Linus Walleij <linus.walleij@linaro.org>
To: Olliver Schinagl <o.schinagl@ultimaker.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Olliver Schinagl <oliver@schinagl.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 9:35 PM, Olliver Schinagl
<o.schinagl@ultimaker.com> wrote:

> From: Olliver Schinagl <oliver@schinagl.nl>
>
> On my previous patch I was overly hasty and made the suffixes string
> array
> const char const *suffixes, instaed of const char * const suffixes. This
> patch corrects that
>
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>

Patch applied.

Yours,
Linus Walleij
