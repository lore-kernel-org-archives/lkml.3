Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaBLNCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:02:05 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60250 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaBLNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:02:04 -0500
MIME-Version: 1.0
In-Reply-To: <1392196213-20576-3-git-send-email-sachin.kamat@linaro.org>
References: <1392196213-20576-1-git-send-email-sachin.kamat@linaro.org>
	<1392196213-20576-3-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 12 Feb 2014 14:02:02 +0100
Message-ID: <CACRpkdZKb1D0LtVpqKDiocA_qXXs2XdBcXs3ahoqr7DScxpJhw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: stw481x: Staticize stw481x_regmap_config
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:10 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> stw481x_regmap_config is local to this file.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
