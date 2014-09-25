Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaIYX3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:29:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56976 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaIYX3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:29:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes-non-critical for 3.18 #1
Date: Fri, 26 Sep 2014 01:28:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1411578865-27232-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1411578865-27232-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409260128.31525.arnd@arndb.de>
X-Provags-ID: V02:K0:+EyjmnM6SjQX/Wo8sRUH3EIY54v8xTFyTFz1ivpL3eh
 61E7hRhcYZmJgD4VadPd+ffAc2g6iqF6Oy9PD2DN2+6/O6zK0S
 iLwBzRaN8DkzFaCOB6JEQgWXb2fwqEMZd+qQWx/j0r209K9ZEN
 mZ/K6Uo57j5gtV/h46BHUkei07WJhf+/mgv5iaXyPMnE0UDDYS
 24pnsSo+n6Ic1Sfj6v9txbf4IGqcqwGToRka0/dbAFO0PwWVzI
 68onof9+URhmRH/7gf6QwxtxGyvGyVxUW2PecLeZZnftU2b0a3
 P5ejDUxAww9OBL172JNHLXwTWGHmTu8iqC5NJDhqfg7Amnknrp
 IrKJT1ZyVjtBIB3SQ3So=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2014, Nicolas Ferre wrote:
> Fixes non critical for AT91:
> - mmc pinmux for at91sam9263 was missing
> - little fix of the old clock implementation

Pulled into next/fixes-non-critical, thanks!

	Arnd
