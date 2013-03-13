Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab3CMSPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:15:20 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56143 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab3CMSPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <1363175026-11016-1-git-send-email-sachin.kamat@linaro.org>
References: <1363175026-11016-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 13 Mar 2013 19:15:18 +0100
Message-ID: <CACRpkdYatBZL=nbpnXPiXH9REv3GJQGe7TH5eJG1S1WAzoQsuA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: generic: Fix compilation error
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 12:43 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> The function definition of pinconf_generic_dump_config is defined
> under CONFIG_DEBUG_FS macro. Define the declaration too under this macro.
>
> Without this patch we get the following build error:
> drivers/built-in.o: In function `pcs_pinconf_config_dbg_show':
> drivers/pinctrl/pinctrl-single.c:726: undefined reference to
> `pinconf_generic_dump_config'
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, applied to my fixes branch.

Yours,
Linus Walleij
