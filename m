Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3HGQYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:24:34 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58647 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3HGQYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <201307231334.21272.heiko@sntech.de>
References: <201307231334.21272.heiko@sntech.de>
Date: Wed, 7 Aug 2013 18:24:32 +0200
Message-ID: <CACRpkdaQde2bmwgEA-V=Uq_faJDRKmj9RyhW-WYE5vRuD9pEyA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: include correct clk header
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 1:34 PM, Heiko Stübner <heiko@sntech.de> wrote:

> The correct header to include for clock handling is clk.h .
> clk-provider.h should not be used in simple clock consumers.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Patch applied.

Yours,
Linus Walleij
