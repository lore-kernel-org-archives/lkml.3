Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3HFXb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:31:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:40951 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3HFXbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:31:24 -0400
Message-ID: <1375831851.12557.74.camel@pasglop>
Subject: Re: [PATCH V2 5/6] cpuidle/powerpc: Backend-powerpc idle driver for
 powernv and pseries.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, rjw@sisk.pl,
        dongsheng.wang@freescale.com, linux-pm@vger.kernel.org
Date: Wed, 07 Aug 2013 09:30:51 +1000
In-Reply-To: <1375830520.5600.23.camel@snotra.buserror.net>
References: <20130731025840.19448.24468.stgit@deepthi>
	 <20130731025934.19448.16658.stgit@deepthi>
	 <1375830520.5600.23.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 18:08 -0500, Scott Wood wrote:
> Here's another example.  get_lppaca() will only build on book3s -- and
> yet we get requests for e500 code to use this file.

Indeed, Besides there is already accessors afaik for lppaca that compile
to nothing on E (and if not they would be trivial to add).

Cheers,
Ben.


