Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3HUWXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:23:35 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:50556 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3HUWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <1376924846-17063-1-git-send-email-broonie@kernel.org>
References: <1376924846-17063-1-git-send-email-broonie@kernel.org>
Date: Thu, 22 Aug 2013 00:23:33 +0200
Message-ID: <CACRpkdaoyjWjJDh3=npqGP5fmAGiXkVsbQuSeJZQ9WepDNoXfw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: palmas: Fix device name in Kconfig text
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 5:07 PM, Mark Brown <broonie@kernel.org> wrote:

> From: Mark Brown <broonie@linaro.org>
>
> The device family is called Palmas so there should be a 's' on the end of
> the name.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

Patch applied with Laxman's ACK.

Thanks!
Linus Walleij
