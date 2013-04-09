Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936552Ab3DIKtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:49:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935298Ab3DIKtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:49:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: DT changes for 3.10 #3
Date: Tue, 9 Apr 2013 12:49:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dgilbert@interlog.com
References: <20130402184947.GA8015@quad.lixom.net> <1365094799-16940-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1365094799-16940-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091249.38903.arnd@arndb.de>
X-Provags-ID: V02:K0:wBqL7yr7dxzxS/gxRGtFN74NmKWdGpFWQ1uIaBaaVkl
 2mNhVnBbhP1BLkatJgfZXfn0Amm0H/vftYvavdR5zLz7MKeVvr
 rGNBCKtXcBsPCvniQ8zq5mrKq66Qedhb5Uf40Tn+hwxCfJLDP3
 PfXHtkJ5g0QucjWTwyLTRWDclubmyuCpRzhesKOuLfvEiGcvix
 mgGiy10+VCoH7zNQFaCh/A9M0ihPYkCfi3m4AmJusiqnyst5l8
 KULhWky8eGUpugadIqFiKnQQJVEmPPKlc+o2xgcTpF9V35oVQN
 N4s7NNL3ZihXcoIq9mfPmUIKFIo2m+f/KtNzu7YH2Jw7FxOtxo
 FtzFxWmP3jhxdmn/XTGs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 April 2013, Nicolas Ferre wrote:
> Here is the refreshed pull-request for AT91 that is dedicated to Device Tree
> modifications. It is stacked on the material that you already have
> for 3.10 in your arm-soc/at91/dt branch.
> Following our discussion with Arnd, I added the non-urgent patches that I
> already proposed too late for 3.9. I also included the moving of macb node
> and kept the original patch.
> 
> As Olof asked, I renamed the Aria board dts file: at91-ariag25.dts and placed
> it in the Makefile. I also took the advantage of this delay to stack two more
> DT related patches.
> 

Pulled into next/dt, thanks!

	Arnd
