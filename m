Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3LTW4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:56:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:27558 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab3LTW4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:56:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,524,1384329600"; 
   d="scan'208";a="455722986"
Date: Fri, 20 Dec 2013 14:56:24 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@Intel.com,
        tony.luck@Intel.com, ruiv.wang@gmail.com, gong.chen@linux.intel.com
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v3]
Message-ID: <20131220225624.GD22695@tassilo.jf.intel.com>
References: <1387554609-9823-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387554609-9823-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 10:50:09AM -0500, Prarit Bhargava wrote:
> I tested across various systems with both the linux.git and linux-next.git
> trees and do not see any false positives.  The patch behaves as expected on
> a system with 590 IRQs allocated at boot time; the system refuses to down cpu
> 62.

I read the patch and it looks good to me

I haven't double checked, but I'm assuming the hot plug locks are held
while you are doing this.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
