Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3COWU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:20:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3COWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:20:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup + soc for 3.10 #1
Date: Fri, 15 Mar 2013 22:17:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <51432265.2060905@atmel.com>
In-Reply-To: <51432265.2060905@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303152217.50432.arnd@arndb.de>
X-Provags-ID: V02:K0:CwJ+V7/oUxoQC5CbdntpkefYTUQF8DLip1T++31vEYa
 LIjHtj/kHX7J9E5BNQU1+S6cShttjsl/IULh8tBCz4R3kXXOBZ
 UEddj9Legu3xieJweYZGBBjqvuSouQzZ5VIUyVNZkiyq/lu0VT
 h9vQkDnZPeXzS7l2gVqLMvYapPe6x0AbTJG41ROiV+n3kbLrb3
 0pE84KlZqmUw0fLjDkfb5cM2tQQwjacWRT2gXhmQfQfX4NtTuQ
 7sYu+rWwUIdjbET9HIVKa2gWdjt+Cnb+fbEBKcyz++W2tp4lDt
 QcdigwXPpIYFjBuThnONCTlJoWFzyMVcB4PpUU3q8PkA94IDIT
 ebF1pQ3r7iZY8yl/VDsQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Nicolas Ferre wrote:
> This is a pull-request targeted to do some cleanup in AT91 Kconfig
> and board-dt-xxx.c files. It will prepare the coming introduction of
> our SAMA5D3 family (Atmel new Cortex-A5) that we will stack on top
> of these modifications soon.
> 

Pulled into next/cleanup branch

	Arnd
