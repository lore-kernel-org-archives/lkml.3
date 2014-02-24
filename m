Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBXJpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:45:41 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43494 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaBXJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <1391108240-16161-1-git-send-email-broonie@kernel.org>
References: <1391108240-16161-1-git-send-email-broonie@kernel.org>
Date: Mon, 24 Feb 2014 10:45:35 +0100
Message-ID: <CACRpkdaBqzb78ybn+0wtQyJF5eO04WqZOD6aABzzkMNffQBnpg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Quiet logging about missing DT nodes when not
 using DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 7:57 PM, Mark Brown <broonie@kernel.org> wrote:

> From: Mark Brown <broonie@linaro.org>
>
> On systems which were not booted using DT it is entirely unsurprising that
> device nodes don't have any DT information and this is going to happen for
> every single device in the system. Make pinctrl be less chatty about this
> situation by only logging in the case where we have DT.
>
> Signed-off-by: Mark Brown <broonie@linaro.org>

Makes perfect sense. Patch applied.

Sorry for leaving it in limbo for so long!

Yours,
Linus Walleij
