Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3LCJg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:36:59 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54106 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3LCJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:36:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131127080640.18384.21957.sendpatchset@w520>
References: <20131127080606.18384.45103.sendpatchset@w520>
	<20131127080640.18384.21957.sendpatchset@w520>
Date: Tue, 3 Dec 2013 10:36:54 +0100
Message-ID: <CACRpkdZMLe-uGPY0psjC_6+kdJecAvnjddnJTMkMNzg43DooiA@mail.gmail.com>
Subject: Re: [PATCH 03/03] pinctrl: sh-pfc: r7s72100 SCIF2 port4, 6 and 8 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 9:06 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Add the remaining SCIF2 pins using the recently introduced macro.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Laurent, please pick this into your stack for my tree.

I guess the pure DTS changes can go directly to Simon's tree?

Yours,
Linus Walleij
