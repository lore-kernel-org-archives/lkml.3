Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaBFNWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:22:06 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62077 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334AbaBFNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:22:04 -0500
MIME-Version: 1.0
In-Reply-To: <1391607694-8608-1-git-send-email-ldewangan@nvidia.com>
References: <1391607694-8608-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 6 Feb 2014 14:22:03 +0100
Message-ID: <CACRpkdb-LCFK0UuxTYMu45Kh-GjPTEBfZr+o8zfD_Y_++urX5w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: return correct error type
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 2:41 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> When memory allocation failed, drive should return error as ENOMEM.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Patch applied for fixes with Stephen's ACK.

Yours,
Linus Walleij
