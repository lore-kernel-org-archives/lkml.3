Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3ILTES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:04:18 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:20185 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3ILTEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:04:16 -0400
Message-ID: <52321022.6060907@tilera.com>
Date: Thu, 12 Sep 2013 15:04:02 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rth@twiddle.net>, <vgupta@synopsys.com>, <linux@arm.linux.org.uk>,
        <tony.luck@intel.com>, <geert@linux-m68k.org>, <monstr@monstr.eu>,
        <ralf@linux-mips.org>, <jejb@parisc-linux.org>,
        <benh@kernel.crashing.org>, <lethal@linux-sh.org>,
        <davem@davemloft.net>, <gxt@mprc.pku.edu.cn>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [PATCH] Kconfig cleanup (PARPORT_PC dependencies)
References: <1379012038-31764-1-git-send-email-msalter@redhat.com>
In-Reply-To: <1379012038-31764-1-git-send-email-msalter@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/2013 2:53 PM, Mark Salter wrote:
> Remove messy dependencies from PARPORT_PC by having it depend on one
> Kconfig symbol (ARCH_MAY_HAVE_PC_PARPORT) and having architectures
> which need it declare ARCH_MAY_HAVE_PC_PARPORT in arch/*/Kconfig.
> New architectures are unlikely to need PARPORT_PC, so this avoids
> having an ever growing list of architectures to exclude. Those
> architectures which do declare ARCH_MAY_HAVE_PC_PARPORT in this
> patch are the ones which have an asm/parport.h.
>
> Signed-off-by: Mark Salter <msalter@redhat.com>

You can actually omit the arch/tile change, since as far as I know there's no way for tile to have PARPORT_PC.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

