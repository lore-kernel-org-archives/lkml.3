Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3FXMao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:30:44 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53193 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3FXMan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <1372072821-22450-1-git-send-email-sachin.kamat@linaro.org>
References: <1372072821-22450-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 24 Jun 2013 14:30:42 +0200
Message-ID: <CACRpkdbHPPaJnkNq90bPTM1at+uzwww3P2mU-HaeNgi7kFNGzw@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: samsung: Staticize drvdata_list
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 1:20 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'drvdata_list' is used only in this file. Make it static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied.

Yours,
Linus Walleij
