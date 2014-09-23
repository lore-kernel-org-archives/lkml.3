Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaIWPAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:00:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53032 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbaIWPAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <1410446415-29410-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410446415-29410-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Tue, 23 Sep 2014 17:00:53 +0200
Message-ID: <CACRpkdZi0XMXN6PG2Q4sSkVtV1ogpK0-O_ZTuccB4NduR4qZ2A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: disable Pull-Down or Pull-Up property
 before enabling Pull-Up or Pull-Down.
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 4:40 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> From: Wenyou Yang <wenyou.yang@atmel.com>
>
> Because the pin's Pull-Up and Pull-Down property is mutually exclusive.
>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Patch applied with Nicolas' ACK.

Yours,
Linus Walleij
