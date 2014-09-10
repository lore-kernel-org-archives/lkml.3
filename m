Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaIJIHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:07:08 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58348 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaIJIHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:07:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-next@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>, linux-kernel@vger.kernel.org,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: linux-next: manual merge of the net-next tree with the arm-soc tree
Date: Wed, 10 Sep 2014 10:06:19 +0200
Message-ID: <4343050.11meBDLdD4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140910144837.5e3089e1@canb.auug.org.au>
References: <20140910144837.5e3089e1@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wkF6jJHwbynMLdansAIW/HehI1UR4+FCX1y0gfUNX+W
 9E3zF9NxCI+cCMlz33nICGmGdjrain+HnlyQtdxQ0LLoN0ocI6
 siQZ3RMglESU+jz1PtNWI7mfSxiOmPBiWMK0zR9BS8a3vKxajY
 Mz/oBrC8yKjD0opb5ZYPd/HNSLbeTt3nDydGxEtuQuTpe5Df+G
 fFptunTufdwwj36+DDM5xwC4CFj5XLuQdoCVZV9qUXMxMhAALU
 P7UWf4B4KKwtfuQZn8QxDVUZRkvIAisTXB9eiXff6RXKjUoc/U
 Z5swRJ8qzcADvlJdu7rXOlysF5pzY08uZ2vFfiDNoKsUDVZ9GG
 GPkCDnl98y87PXXnXTOw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 14:48:37 Stephen Rothwell wrote:
> Today's linux-next merge of the net-next tree got a conflict in
> arch/arm/boot/dts/rk3188-radxarock.dts between commit 4721ab855d1a
> ("ARM: dts: rockchip: add hym8563 rtc to Radxa Rock board") from the
> arm-soc tree and commit c6ec956b73db ("ARM: dts: Enable emac node on
> the rk3188-radxarock boards") from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Thanks, looks good.

	Arnd
