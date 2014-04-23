Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaDWOGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:06:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57994 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755068AbaDWOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:06:13 -0400
Message-ID: <5357C8D2.3030109@free-electrons.com>
Date: Wed, 23 Apr 2014 16:06:10 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: sunxi: dt: list all pinctrl compatible strings
References: <1398173886-9376-1-git-send-email-boris.brezillon@free-electrons.com> <CACRpkdaQZ2VABWpbwEZ1eeMUZuf8SkGermKhiOPPHLQudJ4iqg@mail.gmail.com>
In-Reply-To: <CACRpkdaQZ2VABWpbwEZ1eeMUZuf8SkGermKhiOPPHLQudJ4iqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23/04/2014 15:48, Linus Walleij wrote:
> On Tue, Apr 22, 2014 at 3:38 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>
>> List all sunxi pinctrl compatible strings in order to be able to grep for
>> those values.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Patch applied, but I edited the subject to pinctrl:
> as this is arch neutral and has nothing to do with ARM really.

Thanks.

> Yours,
> Linus Walleij

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

