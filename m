Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3DKRK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:10:57 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:36459 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3DKRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:10:56 -0400
Date: Thu, 11 Apr 2013 19:10:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] cputime_nsecs: use math64.h for nsec resolution
 conversion helpers
Message-ID: <20130411171047.GB17129@somewhere.redhat.com>
References: <1363822467-6275-1-git-send-email-khilman@linaro.org>
 <1363822467-6275-2-git-send-email-khilman@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363822467-6275-2-git-send-email-khilman@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:34:25PM -0700, Kevin Hilman wrote:
> For the nsec resolution conversions to be useable on non 64-bit
> architectures, the helpers in <linux/math64.h> need to be used so the
> right arch-specific 64-bit math helpers can be used (e.g. do_div())
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

Ok the patch is nice!

I'm queuing it.

Thanks.
