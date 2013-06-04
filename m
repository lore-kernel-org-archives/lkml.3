Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3FDOMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:12:45 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57865 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3FDOMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:12:41 -0400
Message-ID: <51ADF5C8.80007@free-electrons.com>
Date: Tue, 04 Jun 2013 16:12:24 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <51A34BF9.5000905@atmel.com> <6343931.uK9ItNlUFg@wuerfel> <51ADF04D.3040703@atmel.com>
In-Reply-To: <51ADF04D.3040703@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 15:49, Nicolas Ferre wrote:
>
> ... simply use this "IS_BUILTIN(CONFIG_PHYLIB)" here -----^^^^^^^^^
> (and not above as suggested by Arnd).
>
> Jean-Christophe, Alexandre: do you agree with this conclusion?
>
> I plan to stack this patch for next at91-fixes batch.
>

Yeah, I prepared and tested that last week but didn't send it yet. I can
do it now if you want but you could probably just edit my patch. I'd
like to fix the other platforms too but that probably can wait.

I believe we would still have to fix the phy_register_fixup*() works as
it is always called from arch/ and is clearly not fool proofed enough.
Maybe DT could help ?

Arnd, do you have any input ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

