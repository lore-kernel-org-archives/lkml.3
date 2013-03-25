Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3CYSZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:25:44 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53092 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3CYSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:25:42 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        poeschel@lemonage.de, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v3] gpio: mcp23s08: convert driver to DT
References: <1362414873-17676-1-git-send-email-larsi@wh2.tu-dresden.de>
	<CACRpkdYYsULLsDQuxoRHp=HXsaOAejwaO-CezdEK4sNprWpDYQ@mail.gmail.com>
Date: Mon, 25 Mar 2013 19:25:33 +0100
In-Reply-To: <CACRpkdYYsULLsDQuxoRHp=HXsaOAejwaO-CezdEK4sNprWpDYQ@mail.gmail.com>
	(Linus Walleij's message of "Fri, 22 Mar 2013 09:33:10 +0100")
Message-ID: <87wqsvbale.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Walleij <linus.walleij@linaro.org> writes:

 Linus> Hi Lars,
 Linus> sorry for taking eternities to review stuff :-(

 Linus> I recommend that you include SPI co-maintainer Mark Brown on
 Linus> subsequent postings.

And me, as I'm the only one who has done any significant work on that
driver since David..

-- 
Bye, Peter Korsgaard
