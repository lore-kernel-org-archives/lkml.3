Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3EPIbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 04:31:52 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:49900 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3EPIbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 04:31:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305151607.54442.arnd@arndb.de>
Date: Thu, 16 May 2013 18:31:38 +1000
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <15FD6543-D04A-4953-A56A-40B27F0026E4@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <1368332581-94691-4-git-send-email-dt.tangr@gmail.com> <201305151607.54442.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16/05/2013, at 12:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> You are missing a binding in Documentation/devicetree, same as for some of
> the other drivers in this series.

Should we be adding a vendor prefix to it too? If so, we're not sure whether to use "ti," or not since this isn't an official port by TI.

> It seems strange to assign the clk_name variable to node->name
> first and then overriding it with the clock-output-names property.
> Is that intentional? If so, please explain it in a comment.
> 

I copied that bit of boilerplate from drivers/clk/clk-fixed-rate.c but I'm guessing it's to use the node name as the clock name unless there is a property called "clock-output-names"

Cheers,
Daniel Tang