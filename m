Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaLHDeC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:34:02 -0500
Received: from ozlabs.org ([103.22.144.67]:48014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaLHDeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:34:00 -0500
Date: Mon, 8 Dec 2014 14:33:51 +1100
From: Paul Mackerras <paulus@samba.org>
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 2/4] powerpc/powernv: Enable Offline CPUs to enter
 deep idle states
Message-ID: <20141208033351.GA4437@drongo>
References: <1417678103-32571-1-git-send-email-shreyas@linux.vnet.ibm.com>
 <1417678103-32571-3-git-send-email-shreyas@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417678103-32571-3-git-send-email-shreyas@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:58:21PM +0530, Shreyas B. Prabhu wrote:
> From: "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>
> 
> The secondary threads should enter deep idle states so as to gain maximum
> powersavings when the entire core is offline. To do so the offline path
> must be made aware of the available deepest idle state. Hence probe the
> device tree for the possible idle states in powernv core code and
> expose the deepest idle state through flags.
> 
> Since the  device tree is probed by the cpuidle driver as well, move
> the parameters required to discover the idle states into an appropriate
> common place to both the driver and the powernv core code.
> 
> Another point is that fastsleep idle state may require workarounds in
> the kernel to function properly. This workaround is introduced in the
> subsequent patches. However neither the cpuidle driver or the hotplug
> path need be bothered about this workaround.
> 
> They will be taken care of by the core powernv code.
> 
> Originally-by: Srivatsa S. Bhat <srivatsa@mit.edu>
> Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>

Reviewed-by: Paul Mackerras <paulus@samba.org>
