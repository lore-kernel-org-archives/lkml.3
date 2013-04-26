Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130Ab3DZHmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:42:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab3DZHmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:42:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 7/6] DMA: shdma: add DT binding documentation
Date: Fri, 26 Apr 2013 09:41:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org, Vinod Koul <vinod.koul@intel.com>,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.1304260823050.30844@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304260823050.30844@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304260941.50821.arnd@arndb.de>
X-Provags-ID: V02:K0:BCXjLYdY/kHour6P30/7xCW7Zg3hHBCsvKW430gdaAc
 B+pnD9J3PyGVnfxRuv6Z01Xc7XJGsmwIgQOmazbPihVC8yw8yY
 yUPCWxU5snEjqbUetLLth/tJBVq8kpETDM8jDhYfCI9z+kPf4P
 gCB6mFnf4s5d8Ac0GFzqZtSn1OlHcmyEmch5a/bRUt1Kq0lSjm
 W6PaaqgQkGziDtSA9bnPApmx/QLEjToEpphHz2e7cBd+ygNXCV
 5wA5t570viuL07ppIcjQX73+jauKmL/H9WF79VF/yrBCn02rVT
 md2PnaayrbwVpdPAGoUsRGJ9Hb91LNEUWq4nWMS+GPX5kar2JY
 ZsimspUghk3knekMFBLk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013, Guennadi Liakhovetski wrote:
> 
> SHDMA uses only standard DMA Device Tree bindings. This patch adds
> documentation, exactly describing the use of the bindings and providing
> examples.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
> 
> This patch adds the missing documentation to the patch series "DMA: shdma: 
> add Device Tree support"
> http://thread.gmane.org/gmane.linux.ports.sh.devel/21972

Acked-by: Arnd Bergmann <arnd@arndb.de>
