Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3CNJe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:34:28 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:51036 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3CNJe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:34:27 -0400
MIME-Version: 1.0
In-Reply-To: <1363253249-3128-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363253249-3128-1-git-send-email-gheorghiuandru@gmail.com>
Date: Thu, 14 Mar 2013 15:04:26 +0530
Message-ID: <CAK9yfHw8df1ktZNYx=998_KmbvUt-be8vGo=kSC52DsEF5utAw@mail.gmail.com>
Subject: Re: [PATCH] drivers: gpio: Use devm_ioremap_resource function
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 March 2013 14:57, Alexandru Gheorghiu <gheorghiuandru@gmail.com> wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error
> handling.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Similar patch has already been submitted:
https://lkml.org/lkml/2013/3/4/124
