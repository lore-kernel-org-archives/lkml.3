Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaKZP1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:27:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaKZP1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:27:20 -0500
Date: Wed, 26 Nov 2014 10:26:46 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zheng.z.yan@intel.com, peterz@infradead.org, eranian@google.com
Subject: Re: perf/x86/intel/uncore: Add Haswell-EP uncore support
Message-ID: <20141126152646.GA7984@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <ak@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	zheng.z.yan@intel.com, peterz@infradead.org, eranian@google.com
References: <20141013152950.11DE26610F1@gitolite.kernel.org>
 <20141125232050.GA9408@redhat.com>
 <20141126141422.GM10824@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126141422.GM10824@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 06:14:22AM -0800, Andi Kleen wrote:
 > > I couldn't quickly decipher which MSRs we're writing to here in the SDM,
 > > but are these really 64-bit wide registers that need 32 bits always set to zero ?
 > 
 > Yes the filter MSRs are only 32bit.

thanks for checking.

 > > I'm wondering if these should be just wrmsr's instead of wrmsrl's.
 > 
 > Can we just shut up coverity please?

I can manually dismiss them, I don't think the checker has the
information to determine this for itself.

	Dave
