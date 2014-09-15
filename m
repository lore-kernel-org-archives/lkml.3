Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaIOMXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:23:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:60244 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaIOMXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:23:41 -0400
Message-ID: <1410783796.31754.85.camel@pasglop>
Subject: Re: [PATCH] cpuidle/powernv: Enter fastsleep on checking if deep
 idle states are allowed
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, mikey@neuling.org,
        linux-pm@vger.kernel.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Mon, 15 Sep 2014 08:23:16 -0400
In-Reply-To: <5416A8B0.8040603@linux.vnet.ibm.com>
References: <20140912110131.7311.86417.stgit@preeti.in.ibm.com>
	 <1410764352.32643.2.camel@concordia> <5416A8B0.8040603@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 14:22 +0530, Preeti U Murthy wrote:
> > We were talking about getting rid of powersave_nap altogether, but I
> think we
> > decided we couldn't, I forget.
> 
> Isn't this a helpful knob to disable cpuidle at runtime? Currently we
> check the value of powersave_nap before entering both nap and
> fastsleep.

It's useful when diagnosing some problems that can be caused by idle
states.

Cheers,
Ben.


