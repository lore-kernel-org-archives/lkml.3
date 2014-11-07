Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaKGNs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:48:28 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58783 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752445AbaKGNs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:48:26 -0500
Date: Fri, 7 Nov 2014 14:45:10 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 01/11] mfd: syscon: Add atmel-matrix registers
 definition
Message-ID: <20141107134510.GC4068@piout.net>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
 <1415203287-21517-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415203287-21517-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 at 17:01:17 +0100, Boris Brezillon wrote :
> AT91 SoCs have a memory range reserved for internal bus configuration.
> Expose those registers so that drivers can make use of the matrix syscon
> declared in at91 DTs.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  include/linux/mfd/syscon/atmel-matrix.h | 114 ++++++++++++++++++++++++++++++++

I think we should stop cluttering the include/linux directory and start
doing what has been done for tegra and create an include/soc/atmel or
include/soc/at91 directory. that's what I was planning to do in my
sdramc/reset series but I didn't get any comment on it.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
