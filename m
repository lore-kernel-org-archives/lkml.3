Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3JHL2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:28:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42441 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3JHL2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:28:22 -0400
MIME-Version: 1.0
In-Reply-To: <1380713832-24488-1-git-send-email-ldewangan@nvidia.com>
References: <1380713832-24488-1-git-send-email-ldewangan@nvidia.com>
Date: Tue, 8 Oct 2013 13:28:21 +0200
Message-ID: <CACRpkdY8wsFGpAKs5U3SCatdbNpzqr+u+oRLSZt81Qx8-EWJHw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: palmas: remove pin config BIAS_PULL_PIN_DEFAULT support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 1:37 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Palmas devices do not support the default bias configuration
> and hence removing this option from valid pin config parameters.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Patch applied with Stephen's ACK.

Yours,
Linus Walleij
