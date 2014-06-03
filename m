Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaFCLhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:37:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:60576 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaFCLhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:37:18 -0400
Message-ID: <538DB360.3010905@mev.co.uk>
Date: Tue, 3 Jun 2014 12:37:04 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: addi_apci_1564: add addi_watchdog dependency
References: <6736164.51V0tJU9Jh@wuerfel>
In-Reply-To: <6736164.51V0tJU9Jh@wuerfel>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-03 11:29, Arnd Bergmann wrote:
> With commit aed3f9d498b ("staging: comedi: addi_apci_1564:
> absorb apci1564_reset()"), the apci 1564 driver has gained
> a dependency on the addi watchdog module, which is not reflected
> correctly in Kconfig, and that can lead to link errors
> when the watchdog is disabled.
>
> This adds an explicit 'select', like it is done in the other
> addi apci drivers that need it.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
