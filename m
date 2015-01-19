Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbbASTVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:21:08 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43842 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbASTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:21:05 -0500
Date: Mon, 19 Jan 2015 11:21:04 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.20 #1
Message-ID: <20150119192104.GF16883@quad.lixom.net>
References: <1421340170-13241-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421340170-13241-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 05:42:50PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Some AT91 cleanup for 3.20, but definitively, more to come soon.
> 
> Thanks, best regards,
> 
> The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:
> 
>   linux 3.19-rc4 (2015-01-11 12:44:53 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup
> 
> for you to fetch changes up to bd87373229e3e8b1a2a42b9eeed4c60fd4418ec6:
> 
>   ARM: at91: remove useless at91rm9200_set_type() (2015-01-15 15:24:06 +0100)
> 
> ----------------------------------------------------------------
> First batch of cleanup for 3.20:
> - Documentation for AT91 SoC
> - Config options, files and functions removal to continue the big !DT
>   cleanup done in 3.19
> - move of debug-macro.S to its usual location

Merged, thanks.


-Olof
