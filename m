Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3FJNoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:44:39 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60913 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3FJNoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <1370685946-3718-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
	<1370685946-3718-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 10 Jun 2013 15:44:37 +0200
Message-ID: <CACRpkdYpkXMS08+xKWUbY_7udYW6zWxXUpothHv0Kr26H91XJg@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: sunxi: Search the description array by pin id
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

> Avoid to use expensive string manipulation functions and search by pin
> id when possible.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Very elegant. Patch applied.

Yours,
Linus Walleij
