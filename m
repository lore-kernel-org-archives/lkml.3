Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBLQYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:24:44 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53353 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBLQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:24:42 -0500
MIME-Version: 1.0
In-Reply-To: <1392026654-5343-11-git-send-email-wsa@the-dreams.de>
References: <1392026654-5343-1-git-send-email-wsa@the-dreams.de>
	<1392026654-5343-11-git-send-email-wsa@the-dreams.de>
Date: Wed, 12 Feb 2014 17:24:41 +0100
Message-ID: <CACRpkdYVENZGXryqL_R4c8bGzb7yEYAcK0bbVrnVuq7dtNxj7w@mail.gmail.com>
Subject: Re: [PATCH 10/17] i2c: i2c-nomadik: deprecate class based instantiation
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Alessandro Rubini <rubini@unipv.it>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:04 AM, Wolfram Sang <wsa@the-dreams.de> wrote:

> Warn users that class based instantiation is going away soon in favour
> of more robust probing and faster bootup times.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
>
> This patch is a suggestion. Looking for an ack by someone who actually uses
> the driver.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
