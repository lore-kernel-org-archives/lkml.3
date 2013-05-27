Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3E0Mru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:47:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3E0Mrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:47:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        andrew@lunn.ch, jason@lakedaemon.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, buytenh@wantstofly.org,
        grant.likely@linaro.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround on DT ethernet
Date: Mon, 27 May 2013 14:47:35 +0200
Message-ID: <2255648.0KEmXfjCx5@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-21-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369655404.3557.33.camel@pasglop>
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com> <51A33447.80305@gmail.com> <1369655404.3557.33.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AESAecNuhxKZK1V7tPDZezcwzFKWi5tTBNiZDDcGnJo
 qAxwDSwrLegQ6Ldcy5+ZyGDxD3GjhvDFn/YP1wq9CpAcjqAW4n
 iChKal+zunJBy7K+S5Vm6cPyuBv+MEcj6IZ8uDQumtJEDdGodW
 X0yXml3jWfn2E/AXCI7hsAWqkaodMRCFylSELej4lQoyUq5wNl
 WL5cmZZAgbjp4Vd0wz9SCOggrMqfcZfAvMREhUa/Gpzd91CCU7
 Zmw0X4DplQpVGDPHWRRxb7mTKRAuaTHElYN+VlTOG5LPi0Qfkh
 LH/CfeRLrPt9ONoNKuBnG/tFgKmpqaHd/UUxU9CEQz6A6IfO+U
 TZpSCIq2B4JH5fBHUOz8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013 21:50:04 Benjamin Herrenschmidt wrote:
> However, that wouldn't help much with the allocation/leak problem,
> though at least it would be easier to use. It could also *try* to re-use
> the current allocation if the new content is of smaller or equal size.

I thought that dtc tried to aggressively save space by folding identical
strings. If you tried to reuse a property that had its contents shared
with another one, you would get interesting results I guess.

	Arnd
