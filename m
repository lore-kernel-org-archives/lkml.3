Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3CAJqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:46:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11036 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3CAJqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:46:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 01 Mar 2013 01:37:43 -0800
Date: Fri, 1 Mar 2013 11:43:14 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130301094314.GG23234@tbergstrom-lnx.Nvidia.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 10:42:28AM +0100, Pali Rohár wrote:
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/Makefile            |    1 +
>  arch/arm/mach-omap2/board-rx51-secure.c |   66 +++++++++++++++++++++++++++++++
>  arch/arm/mach-omap2/board-rx51-secure.h |   36 +++++++++++++++++
>  arch/arm/mach-omap2/board-rx51-smc.S    |   34 ++++++++++++++++
>  arch/arm/mach-omap2/board-rx51.c        |    7 ++++
>  5 files changed, 144 insertions(+)
>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.c
>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.h
>  create mode 100644 arch/arm/mach-omap2/board-rx51-smc.S
> 

Is this necessary? I thought the PPA sets this bit?

Cheers,

Peter.
