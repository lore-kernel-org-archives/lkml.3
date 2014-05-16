Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbaEPPYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:24:16 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33376 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbaEPPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:24:14 -0400
MIME-Version: 1.0
In-Reply-To: <1400020614-18907-1-git-send-email-berthe.ab@gmail.com>
References: <1400020614-18907-1-git-send-email-berthe.ab@gmail.com>
Date: Fri, 16 May 2014 17:24:13 +0200
Message-ID: <CACRpkdZ4aQq-z6Rk4C1pBEMDdgu5ijWQ8gyr3REigx4uEPs3eg@mail.gmail.com>
Subject: Re: [PATCH] gpio: gpioep93xx: use devm functions
From: Linus Walleij <linus.walleij@linaro.org>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:36 AM, abdoulaye berthe <berthe.ab@gmail.com> wrote:

> This uses devm functions for mem allocation
>
> Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>

Patch applied, thanks it's a real nice cleanup.

Yours,
Linus Walleij
