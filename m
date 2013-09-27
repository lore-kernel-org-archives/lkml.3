Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab3I0Nxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:53:44 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46917 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3I0Nxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <1380199684-20126-2-git-send-email-ldewangan@nvidia.com>
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
	<1380199684-20126-2-git-send-email-ldewangan@nvidia.com>
Date: Fri, 27 Sep 2013 15:53:40 +0200
Message-ID: <CACRpkdbAXzsSZLEZhMaL1f=2M3ZRpSz+xDzrFaok2ufpj0otGA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: palmas: remove non-require function
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 2:48 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Palmas pinmux and pin configuration support the single pin level
> configuration in place of pin group.
>
> Hence it is only require to pin_config_{set|get} and do not require
> pin_config_group_{set|get}. As core framework already check for
> require APIs availability, it is not require to implement as dummy
> for non-require ops and so removing it.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Patch applied.

Yours,
Linus Walleij
