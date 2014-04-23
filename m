Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaDWNsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:48:11 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:63232 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaDWNsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:48:02 -0400
MIME-Version: 1.0
In-Reply-To: <1398173886-9376-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398173886-9376-1-git-send-email-boris.brezillon@free-electrons.com>
Date: Wed, 23 Apr 2014 15:48:01 +0200
Message-ID: <CACRpkdaQZ2VABWpbwEZ1eeMUZuf8SkGermKhiOPPHLQudJ4iqg@mail.gmail.com>
Subject: Re: [PATCH] ARM: sunxi: dt: list all pinctrl compatible strings
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 3:38 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:

> List all sunxi pinctrl compatible strings in order to be able to grep for
> those values.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Patch applied, but I edited the subject to pinctrl:
as this is arch neutral and has nothing to do with ARM really.

Yours,
Linus Walleij
