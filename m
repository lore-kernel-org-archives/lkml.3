Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3FJN4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:56:04 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60379 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3FJN4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:56:02 -0400
MIME-Version: 1.0
In-Reply-To: <1370685946-3718-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
	<1370685946-3718-4-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 10 Jun 2013 15:56:01 +0200
Message-ID: <CACRpkdbE4LJkVhw5H=1i2Kt4QLMqOCt8S_X32xp1=Q=vDxogrw@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: sunxi: Add external interrupt functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 12:05 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The A10 and A13 has a few pins that can be muxed into a particular
> function that can be used as an interrupt source. Add the available
> pins for such functions to the A10 and A13 description array.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied.

Yours,
Linus Walleij
