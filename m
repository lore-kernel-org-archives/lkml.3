Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab3EFNpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:45:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3EFNp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:45:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@denx.de>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Date: Mon, 6 May 2013 15:45:22 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, dinguyen@altera.com, wd@denx.de,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        johnstul@us.ibm.com, tglx@linutronix.de,
        kernel list <linux-kernel@vger.kernel.org>
References: <20130426121433.GA16249@amd.pavel.ucw.cz> <20130426214313.GB24891@amd.pavel.ucw.cz> <20130506124814.GA28259@amd.pavel.ucw.cz>
In-Reply-To: <20130506124814.GA28259@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305061545.22587.arnd@arndb.de>
X-Provags-ID: V02:K0:r/2u+xCtT28siBGYUu99ktP1gzPgIATwVjfEgjPhL8c
 mbM1bzol05DbBulAeftrqysKWEE1KqMaXU7uXNYASj9FCQhmMs
 VNQlAwzOy5w7bkFluD7nYwwOC6fpnMKLP0baj7UPwE+h2uP2r2
 NUGwkCjuLXZaLNm0iunto4yaR16HXOl06dyiRVDSJuyHbe/nZK
 xwfKxQ+nREcmQPjUYuQu9EhY3dEtRKMw725Qh9ly9mDsNyiVNP
 WyDS0uoLyOeO7Jmgb2QrtdwTpP3gS66nHGOVuQuIXMal20A5gx
 kW4KcXsK5S8Ce+6Wa7Tcasc45X4mjraDGTWWY6n1Sl0gp2MksZ
 FyFpnj9n3sLabzCHOIwY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 May 2013, Pavel Machek wrote:
> 
> Hi!
> 
> Ping? Previous version was tested by Dinh, and this one is based on
> Jamie's updates, so I assume it is acceptable for him, too.
> 
> It brings two platforms closer together, and makes time actually work
> on socfpga. It would be good to get it applied.

Who should apply it? I guess it needs to go through arm-soc with all the
other clocksource changes already queued up there. Can we have an Ack
from Jamie and from the clocksource maintainers?

	Arnd
