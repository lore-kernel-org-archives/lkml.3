Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3DXXUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:20:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42690 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758073Ab3DXXUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:20:47 -0400
Date: Thu, 25 Apr 2013 00:20:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Message-ID: <20130424232041.GC2619@decadent.org.uk>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] Fix perf LBR filtering
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:04:53PM -0700, Andi Kleen wrote:
[....]
> Should be applied to applicable stable branches too. The problem
> goes back a long time.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
[...]

This is not the correct way to submit a change to stable.
See Documentation/stable_kernel_rules.txt
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
