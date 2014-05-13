Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbaEMIpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:45:31 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49607 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318AbaEMIpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMi_0fT4UbfGUp9jkrwYMXgfxC5gmXOBviU9PjAutPdHiw@mail.gmail.com>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
	<1395505004-22650-2-git-send-email-bigeasy@linutronix.de>
	<CAOesGMi_0fT4UbfGUp9jkrwYMXgfxC5gmXOBviU9PjAutPdHiw@mail.gmail.com>
Date: Tue, 13 May 2014 10:45:24 +0200
Message-ID: <CACRpkdZ+OG0FXkgnkdiyhRobSvo+9=ouXc6qes_UCGhitFhTXQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] ARM: dts: socfpga: add gpio pieces
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 12:02 AM, Olof Johansson <olof@lixom.net> wrote:

> ... or is there some underlying reason for having the two-layer
> approach that isn't obvious from this device tree?

There is, as explained by Alan. One coherent memory range with
several individual ports.

Yours,
Linus Walleij
