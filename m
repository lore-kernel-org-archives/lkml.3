Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3A3KBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:01:34 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41774 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3A3KBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:01:32 -0500
MIME-Version: 1.0
In-Reply-To: <1359019860-3428-1-git-send-email-sachin.kamat@linaro.org>
References: <1359019860-3428-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 30 Jan 2013 11:01:31 +0100
Message-ID: <CACRpkdZ987VOqynKqjvVNywXyP8+rMnfronAhTZwDQVr16p0UQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: core: Make pinctrl_release static
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:31 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'pinctrl_release' is used only in this file. Hence make it static.
>
> Without this patch we get the following sparse error:
> drivers/pinctrl/core.c:815:6: warning:
> symbol 'pinctrl_release' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks! Patch applied.

Yours,
Linus Walleij
