Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaJ1RD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:03:29 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40713 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1RD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:03:28 -0400
MIME-Version: 1.0
In-Reply-To: <2697554.Rv8qaADZsg@diego>
References: <1413913655-22351-1-git-send-email-dianders@chromium.org>
	<1413913655-22351-3-git-send-email-dianders@chromium.org>
	<2697554.Rv8qaADZsg@diego>
Date: Tue, 28 Oct 2014 18:03:27 +0100
Message-ID: <CACRpkdas7K-JUZJSRsgmcBVdxK+mb3VV7TxFXYh91d4n7+eizQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] pinctrl: rockchip: Parse pin groups before calling pinctrl_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 6:26 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Dienstag, 21. Oktober 2014, 10:47:34 schrieb Doug Anderson:
>> Just like in (529301c pinctrl: samsung: Parse pin groups before
>> calling pinctrl_register()), Rockchip also needs to parse pin groups
>> earlier to make hogs work.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Tested-by: Chris Zhong <zyw@rock-chips.com>
>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Heiko, can you collect this for a pull request?

Yours,
Linus Walleij
