Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3H1LZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:25:59 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58774 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3H1LZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:25:58 -0400
MIME-Version: 1.0
In-Reply-To: <1377613817.14731.1.camel@phoenix>
References: <1377613817.14731.1.camel@phoenix>
Date: Wed, 28 Aug 2013 13:25:57 +0200
Message-ID: <CACRpkdbJMG-MbBrt19kj_NTrarhcHfDCppciuL93fT95Mby7MA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: rockchip: Implement .request() and .free()
 callbacks on the GPIO chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 4:30 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Implement .request() and .free() callbacks on the GPIO chips to inform pinctrl
> when a GPIO is requested or freed.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Ohhh that will have semantic effects so really need to wait
for Heiko's opinion on this one.

BTW: Axel are you working with this system?

Yours,
Linus Walleij
