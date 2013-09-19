Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3ISNcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:32:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63767 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3ISNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <1378218483-19532-1-git-send-email-ldewangan@nvidia.com>
References: <1378218483-19532-1-git-send-email-ldewangan@nvidia.com>
Date: Thu, 19 Sep 2013 15:32:21 +0200
Message-ID: <CACRpkdbrvSS0n-qS6nqe7Z4-55atgQzieFPmhYDDugvYPpL83g@mail.gmail.com>
Subject: Re: [PATCH] gpio: palmas: add support for TPS80036
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 4:28 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> TI Palmas series device TPS80036 supports 16 GPIOs.
> Register its all 16 gpios when this device is selected.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Patch applied.

Yours,
Linus Walleij
