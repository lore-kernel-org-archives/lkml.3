Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaBYWkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:40:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:35391 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaBYWkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:40:36 -0500
Message-ID: <1393368002.6314.10.camel@pasglop>
Subject: Re: [PATCH] powerpc: warn users of smt-snooze-delay that the API
 isn't there anymore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Olof Johansson <olof@lixom.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 09:40:02 +1100
In-Reply-To: <530C4D57.1030905@linux.vnet.ibm.com>
References: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
	 <530C4D57.1030905@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 13:29 +0530, Deepthi Dharwar wrote:
> We currently do not use smt-snooze-delay in the kernel.
> The sysfs entries needs to  be retained until we do a clean up
> ppc64_cpu
> util that uses these entries to determine SMT,
> clean up patch for this has already been posted out by Prerna.
> Once, we have the ppc64_cpu changes in, we can look to clean up these
> parts from the kernel.

We generally shouldn't change user visible interfaces.

People still have old versions of ppc64_cpu, we must not break them

Cheers,
Ben.


