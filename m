Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3DSSt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:49:29 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51766 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3DSSt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:49:27 -0400
Date: Fri, 19 Apr 2013 11:49:30 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: soc for 3.10 #3
Message-ID: <20130419184930.GB30836@quad.lixom.net>
References: <1366296702-26436-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366296702-26436-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Thu, Apr 18, 2013 at 04:51:42PM +0200, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> Third pull-request for AT91 SoC support based on material that you already have
> in your arm-soc/at91/soc branch.
> Not very core changes here but interesting enhancements.
> 
> Thanks, best regards,
> 
> The following changes since commit 471c9e786596c4f028c67c7e9de0703b49cab2a9:
> 
>   ARM: at91: add defconfig for SAMA5 (2013-03-26 12:18:05 +0100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-soc

The warning makes sense to pick up now, and the other patch seems well
contained and harmless.

I'll merge this branch into late/cleanup even though it is getting very
close to the merge window.


-Olof
