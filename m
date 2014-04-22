Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaDVLj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:39:27 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:43734 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaDVLjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <1397137966-30818-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
	<1397137966-30818-2-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 22 Apr 2014 13:39:24 +0200
Message-ID: <CACRpkdZrf-rrPUVc-rhH1_ovYnRKbg5+D76EM_wG2A3Xpfj5OQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] pinctrl: sunxi: check clk_prepare_enable return value
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dev@linux-sunxi.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:52 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:

> Check the clk_prepare_enable return value to avoid false positive probe.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Patch applied with Maxime's ACK.

Yours,
Linus Walleij
