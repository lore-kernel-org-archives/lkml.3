Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3FQPvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:51:39 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62488 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3FQPv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:51:26 -0400
MIME-Version: 1.0
In-Reply-To: <20926.42315.907448.451620@ipc1.ka-ro>
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com>
	<20926.42315.907448.451620@ipc1.ka-ro>
Date: Mon, 17 Jun 2013 17:51:26 +0200
Message-ID: <CACRpkdZXd=yOrS5KPW-Rx4SQM_9p7Hwyn4LrrCJtavKG2-vjjA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@nvidia.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 7:57 AM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
> Linus Walleij writes:

>> - *   if it is 0, pull-up is disabled.
>> + *   if it is 0, pull-up it total, i.e. the pin is connected to VDD.
>                             ^^
> 'is'?

Thanks for noticing, fixed this up when applying.

Yours,
Linus Walleij
