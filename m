Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaJBRKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:10:09 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54245 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaJBRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:10:07 -0400
Date: Thu, 2 Oct 2014 19:08:48 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH 1/6] ARM: meson: add meson8 machine definition
Message-ID: <20141002170848.GB29052@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
 <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
 <6568653.UtyvOjrQBb@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6568653.UtyvOjrQBb@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:28:14AM +0200, Arnd Bergmann wrote:
> On Wednesday 01 October 2014 23:29:41 Beniamino Galvani wrote:
> >  DT_MACHINE_START(AML8726_MX, "Amlogic Meson6 platform")
> >         .dt_compat      = m6_common_board_compat,
> >  MACHINE_END
> >  
> > +DT_MACHINE_START(MESON8, "Amlogic Meson8 platform")
> > +       .dt_compat      = m8_common_board_compat,
> > +MACHINE_END
> 
> One more thing: since this is a cortex-a9, don't you have to enable
> the l2x0 cache controller explicitly? I think you need a
> ".l2c_aux_mask   = ~0," entry here.

Will do, thanks.

Beniamino
