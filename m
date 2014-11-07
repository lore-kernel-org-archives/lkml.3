Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaKGOPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:15:00 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59307 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708AbaKGOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:14:58 -0500
Date: Fri, 7 Nov 2014 15:14:55 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
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
Message-ID: <20141107151455.75c73416@bbrezillon>
In-Reply-To: <20141107134510.GC4068@piout.net>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
	<1415203287-21517-2-git-send-email-boris.brezillon@free-electrons.com>
	<20141107134510.GC4068@piout.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Fri, 7 Nov 2014 14:45:10 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> On 05/11/2014 at 17:01:17 +0100, Boris Brezillon wrote :
> > AT91 SoCs have a memory range reserved for internal bus configuration.
> > Expose those registers so that drivers can make use of the matrix syscon
> > declared in at91 DTs.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  include/linux/mfd/syscon/atmel-matrix.h | 114 ++++++++++++++++++++++++++++++++
> 
> I think we should stop cluttering the include/linux directory and start
> doing what has been done for tegra and create an include/soc/atmel or
> include/soc/at91 directory. that's what I was planning to do in my
> sdramc/reset series but I didn't get any comment on it.
> 

I'll let MFD and ARM maintainers decide, but other syscon drivers are
using this directory to define their registers...

Regards,

Boris
-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
