Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3C0Vqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:46:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:47730 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3C0Vqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <1363322223-19850-1-git-send-email-sachin.kamat@linaro.org>
References: <1363322223-19850-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 27 Mar 2013 22:46:38 +0100
Message-ID: <CACRpkdb5fDq7p_OERVUmqTxq4g8-PsexR4MvjtVxGw5SwkQN1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: at91: Remove duplicate const
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 5:37 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> const declared twice. Fixes the following sparse warning:
> drivers/pinctrl/pinctrl-at91.c:815:21: warning: duplicate const
> drivers/pinctrl/pinctrl-at91.c:849:21: warning: duplicate const
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied, thanks!

Yours,
Linus Walleij
