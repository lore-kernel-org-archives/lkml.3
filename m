Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018Ab3KGFBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:01:32 -0500
Received: from gate.crashing.org ([63.228.1.57]:43676 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3KGFBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:01:31 -0500
Message-ID: <1383800462.4776.165.camel@pasglop>
Subject: Re: [PATCH V7 5/7] POWER/cpuidle: Generic POWER CPUIDLE driver
 supporting PSERIES.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        scottwood@freescale.com, srivatsa.bhat@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com
Date: Thu, 07 Nov 2013 16:01:02 +1100
In-Reply-To: <527B13C8.9030602@linux.vnet.ibm.com>
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com>
	 <20131029110148.31547.8944.stgit@deepthi.in.ibm.com>
	 <527AAF1D.5080605@linaro.org> <527B13C8.9030602@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 09:45 +0530, Deepthi Dharwar wrote:
> 'powerpc' would be very generic arch and would comprise of all platforms
> including embedded 32/64 bit to server 64 bit (similar to that of ARM).
> This driver does not intend to support complete powerpc arch, but just
> PSERIES and POWERNV platforms termed as 'POWER' processors. So to avoid
> confusion btw 'power mgmt' and 'POWER' archs, I have prefixed both the
> driver and file names with 'IBM'namely ibm-power-driver, cpuidle-ibm-power.

Why not book3s ? powerpc-book3s ?

That's what we use in other places to differenciate between the families

Ben.


