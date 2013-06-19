Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826Ab3FSPut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:50:49 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:45316 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <1371606813-5575-3-git-send-email-rvaswani@codeaurora.org>
References: <1371606813-5575-1-git-send-email-rvaswani@codeaurora.org>
	<1371606813-5575-3-git-send-email-rvaswani@codeaurora.org>
Date: Wed, 19 Jun 2013 21:20:42 +0530
Message-ID: <CADTbHxoVnD8nvabwJ8fX-_fkr5KZwYeLF3CWTVrNiqxW5oL40Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] drivers: gpio: msm: Fix the error condition for
 reading ngpio
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jun 19, 2013 at 7:23 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>
> of_property_read_u32 return 0 on success. The check was using a ! to
> return error. Fix the if condition.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  drivers/gpio/gpio-msm-v2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Appropriate change.

Reviewed-by: Pankaj Jangra  <jangra.pankaj9@gmail.com>

Regards,
Pankaj Jangra
