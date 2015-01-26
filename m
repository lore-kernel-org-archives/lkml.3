Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbbAZTBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:01:13 -0500
Received: from down.free-electrons.com ([37.187.137.238]:38167 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753120AbbAZTBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:01:10 -0500
Date: Mon, 26 Jan 2015 20:01:07 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] ARM: at91: at91rm9200: set idle and restart from
 rm9200_dt_device_init()
Message-ID: <20150126190107.GA11867@piout.net>
References: <1421359100-8930-12-git-send-email-alexandre.belloni@free-electrons.com>
 <1422295713-26549-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422295713-26549-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/2015 at 19:08:33 +0100, Nicolas Ferre wrote :
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> Setup arm_pm_idle and arm_pm_restart function pointers from
> rm9200_dt_device_init() function to simplify the at91rm9200 initialization
> process.
> This same move is already done for the sam9s.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> [nicolas.ferre@atmel.com: adapt patch to newer series]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91rm9200.c      | 14 --------------
>  arch/arm/mach-at91/board-dt-rm9200.c | 14 ++++++++++++++
>  2 files changed, 14 insertions(+), 14 deletions(-)

I'm pretty sure Arnd wanted us to get rid of the board-dt-* files and
only keep the soc files. Anyway, board-dt doesn't mean anything anymore
since all the boards are dt enabled...

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
