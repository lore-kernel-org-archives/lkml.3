Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3HUW2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:28:48 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62930 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3HUW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1377084218-13858-1-git-send-email-ldewangan@nvidia.com>
References: <1377084218-13858-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 22 Aug 2013 00:28:46 +0200
Message-ID: <CACRpkdZjrd5xCcKTOMoYqnGVyfjKtN7NOpAw_Vp7XoJsqi_4oQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: utils : add support to pass config type
 in generic util APIs
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 1:23 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Add support to pass the config type like GROUP or PIN when using
> the utils or generic pin configuration APIs. This will make the
> APIs more generic.
>
> Added additional inline APIs such that it can be use directly as
> callback for the pinctrl_ops.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Remove separate implementation for pins and group for
>   pinctrl_utils_dt_free_map and improve this function
>   to support both i.e. PINS and GROUPs.

Patch applied with Stephen's tags.

Yours,
Linus Walleij
