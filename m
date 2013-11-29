Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3K2K3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:29:55 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51765 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3K2K3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:29:52 -0500
MIME-Version: 1.0
In-Reply-To: <20131127080621.18384.85008.sendpatchset@w520>
References: <20131127080606.18384.45103.sendpatchset@w520>
	<20131127080621.18384.85008.sendpatchset@w520>
Date: Fri, 29 Nov 2013 11:29:51 +0100
Message-ID: <CACRpkdbUvitwMQ+YjMonCZAJR_9VZMai_4etZE091vDHdFWZmA@mail.gmail.com>
Subject: Re: [PATCH 01/03] pinctrl: sh-pfc: r7s72100 SCIF2 port3 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 9:06 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
>
> Add support for SCIF2 port3 pin functions SCK, TXD and RXD to the
> r7s72100 PINCTRL code. There are two possible pins that can be used
> for TXD (Port 3 Pin 0 Function 6 and Port 3 Pin 1 Function 4) and
> because of that are the data pins broken out in separate TXD and RXD.
>
> This format is similar to other sh-pfc code, but a following patch
> converts this to less verbose and less readable code.
>
> Signed-off-by: Magnus Damm <damm@opensource.se>

Regarding this and other PFC patches: Laurent can you help me
out with collecting the patches for my pinctrl tree and send me
a pull request when it's all tested together, like you did in the
last kernel cycle?

Yours,
Linus Walleij
