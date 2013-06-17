Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3FQIyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:54:12 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:34000 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3FQIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <1370864113-17895-6-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
	<1370864113-17895-6-git-send-email-tushar.behera@linaro.org>
Date: Mon, 17 Jun 2013 10:54:10 +0200
Message-ID: <CACRpkdZx1+7Mib1uuCbczuH4uJBdTuyCaxbXreaPJ3Tzjq7inw@mail.gmail.com>
Subject: Re: [PATCH 05/15] gpio-sta2x11: Convert to use devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        thierry.reding@gmail.com, Patch Tracking <patches@linaro.org>,
        linux-gpio@vger.kernel.org, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 1:35 PM, Tushar Behera <tushar.behera@linaro.org> wrote:

> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> CC: linux-gpio@vger.kernel.org
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Linus Walleij <linus.walleij@linaro.org>

Patch applied.

Yours,
Linus Walleij
