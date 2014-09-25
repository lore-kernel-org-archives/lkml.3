Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaIYWRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:17:11 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59804 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaIYWRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:17:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.18 #2
Date: Fri, 26 Sep 2014 00:17:01 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
References: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1411391733-28891-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409260017.01469.arnd@arndb.de>
X-Provags-ID: V02:K0:4K57kj9QywkbAMNmtnFJIhEyyz7NPHXwJsKmjLbTRwl
 D8u/EcALsQdMX3o++ClLU9QwkQyDIPNOoOGXpE5eRc4x+FXZcY
 0kRsh5D9/40k9oU2Msot+Gh2n+bthC3DpmkJ3//AzT+a8/znA3
 hC4tCqUoc/ORVvZL7fLOJBvv08brefA17q4lcpmwU8vbqjUFMB
 qzVNmTI3i4W22YNcRizdCawa42xFdwnCSvInuPq//uKuEsrPqA
 lXWbdz/BYTe4HiYkzr0ErHHTdAbgTEulWb000ED98xBXHMssBs
 APM7pO+bqnup+3IL28J65WVqZanj2PduCkOs/OGcspsxjyUsF0
 T2oIHQHpxQFk9NobgQ0c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2014, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is the second SoC pull-request for AT91 and it's dedicated to the addition
> of our new SAMA5D4: C-A5+neon+L2CC+vdec (in sort). The AT91 SoC support is now
> pretty simple in relation with the enhancements done recently.
> The patches go on top of the previous tag at91-soc and has no dependency.
> 
> The merge with other AT91 branches can lead to little conflicts that I resolved
> for you in the at91-3.18-resolved2 branch that you can take as an example.
> 
> Thanks, best regards,
> 
> The following changes since commit 5db722eeba0051c68e638114f6720e715b03cd2c:
> 
>   ARM: at91: Remove the support for the RSI EWS board (2014-09-19 13:13:23 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-soc2
> 
> for you to fetch changes up to 02037a9719fa89b7e5dc25cb22afc06c4eae406e:
> 
>   ARM: at91: document Atmel SMART compatibles (2014-09-22 14:42:40 +0200)
> 
> ----------------------------------------------------------------
> Second SoC batch for 3.18:
> - introduction of the new SAMA5D4 SoC and associated Evaluation Kit
> - low level soc detection and early printk code
> - taking advantage of this, documentation of all AT91 SoC DT strings

Pulled into next/soc, thanks!

	Arnd
