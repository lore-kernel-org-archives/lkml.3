Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3GWOGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:06:48 -0400
Received: from ozlabs.org ([203.10.76.45]:57387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442Ab3GWOGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:06:47 -0400
Date: Wed, 24 Jul 2013 00:06:45 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] cpuidle/powernv: cpuidle backend driver for powernv
Message-ID: <20130723140645.GI31944@concordia>
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
 <20130723090137.7291.36657.stgit@deepthi.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723090137.7291.36657.stgit@deepthi.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 02:31:41PM +0530, Deepthi Dharwar wrote:
> This patch implements a back-end cpuidle driver for
> powernv calling power7_nap and snooze idle states.
> This can be extended by adding more idle states
> in the future to the existing framework.

Other than the state table and a few minor details this looks almost
identical to the pseries driver. Can we not have a single version in
sysdev and isolate just the differences?

cheers
