Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3FQIZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:25:31 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61309 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3FQIZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <1370851541-23629-1-git-send-email-tushar.behera@linaro.org>
References: <1370851541-23629-1-git-send-email-tushar.behera@linaro.org>
Date: Mon, 17 Jun 2013 10:25:29 +0200
Message-ID: <CACRpkdYEDK3GQ4DG2tBXqS57HqzAyC0BrDy77=bMyxVRokDcMg@mail.gmail.com>
Subject: Re: [PATCH] gpio_msm: Remove __devinit attribute
From: Linus Walleij <linus.walleij@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:05 AM, Tushar Behera
<tushar.behera@linaro.org> wrote:

> The definition of __devinit has been removed from the kernel. Remove
> this to fix compilation error.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

I already had a similar patch from Stephen Boyd queued so
dropping this.

Yours,
Linus Walleij
