Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbaCQOud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:50:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:50415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaCQOuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:50:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.15 #1
Date: Mon, 17 Mar 2014 15:47:45 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Jacques Hiblot" <jjhiblot@traphandler.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
References: <1394647325-29757-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1394647325-29757-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403171547.45327.arnd@arndb.de>
X-Provags-ID: V02:K0:v8BAN+JOM7mkL8IXL7Kqd7mnJuotCBtKeu/vZZizZ+K
 4uAV82le0lZGGGdvcFDKpURsNd41yZgcuPNEeyZcvRQ9e2zNKo
 1oBJl6zlFe93+i79eUYRr87rEhndKuH7Vrf0Sm1t6g9xl9w0kg
 G7yT3f3SQPM1y5NCkchBDIx8U+QzjZHaxNnvBXWoH7t2SD4dEP
 lPi/vQ7/mU2/Dk6I2i5ykoCT136jJ0Bct1QM48REvpiRiNmIP6
 cXof4jPjeHIiWPDArATD5JRh9ia82MCK1d6pvDA0gXpt1PnhmO
 EvTkWhZJwaP0h+phEoW8VEOkBvs9WtnTQWoOPjUweWKkTJoYwU
 RlU9GVqnSWshBXym1aDruCw6kjD2uBpZcxACQCB5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is the first AT91 pull-request for 3.15, and a cleanup one. The most of it
> is the conversion of two more Atmel SoCs to Device Tree. These are older that
> the ones already converted. Moreover, they already use the CCF so there is no
> need to come back on this later (maybe to remove some code when the other
> non-DT boards are converted as well).
> The defconfig update was needed because they were pretty old and some
> interesting options were missing.

Pulled into next/cleanup, thanks!

	Arnd

