Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3H2HLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:11:54 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:65042 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3H2HLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <1377613817.14731.1.camel@phoenix>
References: <1377613817.14731.1.camel@phoenix>
Date: Thu, 29 Aug 2013 09:11:52 +0200
Message-ID: <CACRpkdb_pM=k0xL0XEq=c5Hu5EtCxJH9Hw6Zy_j5YFc87ococA@mail.gmail.com>
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

Patch applied with Heiko's tags.

Yours,
Linus Walleij
