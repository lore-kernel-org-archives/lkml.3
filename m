Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaKJI7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:59:07 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:37164 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaKJI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:59:05 -0500
Message-ID: <54607E53.4060105@atmel.com>
Date: Mon, 10 Nov 2014 09:58:59 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ulf Hansson <ulf.hansson@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>
Subject: Re: linux-next: manual merge of the mmc-uh tree with the arm-soc
 tree
References: <20141110125637.30fe73b9@canb.auug.org.au>
In-Reply-To: <20141110125637.30fe73b9@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 02:56, Stephen Rothwell :
> Hi Ulf,
> 
> Today's linux-next merge of the mmc-uh tree got a conflict in
> arch/arm/mach-at91/at91sam9g45_devices.c between commit 4bf7753b8ab7
> ("ARM: at91: remove at91sam9g45/9m10 legacy board support") from the
> arm-soc tree and commit 4049854c41e0 ("ARM: at91: remove
> mach/atmel-mci.h") from the mmc-uh tree.
> 
> I fixed it up (I just removed the file) and can carry the fix as
> necessary (no action is required).

Well fixed. Thanks Stephen.

Bye,
-- 
Nicolas Ferre
