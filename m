Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbbAOQNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:13:16 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:58926 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbAOQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:13:14 -0500
MIME-Version: 1.0
In-Reply-To: <1421139747.22660.76.camel@x220>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-4-git-send-email-ricardo.ribalda@gmail.com>
	<1421139747.22660.76.camel@x220>
Date: Thu, 15 Jan 2015 17:13:13 +0100
Message-ID: <CACRpkdbvwKich5Lp3WDckRnRpb93=CF3yCkRCzXV4NQqGLENvg@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] gpio/xilinx: Add support for X86 Arch
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:02 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Wed, 2014-12-17 at 16:51 +0100, Ricardo Ribalda Delgado wrote:
>> Core can be accessed via PCIe on X86 platform.
>> This patch also allows the driver to be used as module.
>>
>> Acked-by: Michal Simek <michal.simek@xilinx.com>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/gpio/Kconfig       | 4 ++--
>>  drivers/gpio/gpio-xilinx.c | 2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> This patch became c586b3075d5b ("gpio/xilinx: Add support for X86 Arch")
> in today's linux-next (next-20150113). I noticed because a script I use
> to check linux-next spotted a problem in it.

Yes the topic line was way too long so I just took my axe
and chopped of a string.

Yours,
Linus Walleij
