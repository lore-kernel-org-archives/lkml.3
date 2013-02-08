Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab3BHCee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:34:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:49940 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461Ab3BHCed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:34:33 -0500
Message-ID: <1360290858.2650.50.camel@pasglop>
Subject: Re: kernel BUG at arch/powerpc/mm/hash_utils_64.c:1223!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2013 13:34:18 +1100
In-Reply-To: <20130207230900.GC3178@blackmetal.musicnaut.iki.fi>
References: <20130207230900.GC3178@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 01:09 +0200, Aaro Koskinen wrote:
> 
> I get this BUG when enabling DEBUG_PAGEALLOC with 3.8-rc6+
> (6bacaa9ddacb71c691d32c678d37bc59ffc71fac) on G5 PPC.
> 
> It seems to be fairly reproducible - I saw it 3 times, soon after
> booting
> while running a compilation job on ext3 partition. Unfortunately I'm
> not able to capture the full trace at the moment. Kernel config is
> below.

Thanks, I'll investigate.

Cheers,
Ben.


