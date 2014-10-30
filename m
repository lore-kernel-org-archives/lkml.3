Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbaJ3Rxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:53:34 -0400
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:47114 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaJ3Rxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:53:32 -0400
X-Greylist: delayed 1985 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 13:53:31 EDT
Message-ID: <1414689620.11523.5.camel@hellion.org.uk>
Subject: Re: [RFC PATCH 1/1] arm64: Fix up /proc/cpuinfo
From: Ian Campbell <ijc@hellion.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "ghackmann@google.com" <ghackmann@google.com>,
        Serban Constantinescu <Serban.Constantinescu@arm.com>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 Oct 2014 17:20:20 +0000
In-Reply-To: <20141030171521.GL32589@arm.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
	 <1414159000-27059-2-git-send-email-mark.rutland@arm.com>
	 <20141030171521.GL32589@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 17:15 +0000, Will Deacon wrote:
> Hi Mark,
> 
> On Fri, Oct 24, 2014 at 02:56:40PM +0100, Mark Rutland wrote:
> > Commit d7a49086f263164a (arm64: cpuinfo: print info for all CPUs)
> > attempted to clean up /proc/cpuinfo, but due to concerns regarding
> > further changes was reverted in commit 5e39977edf6500fd (Revert "arm64:
> > cpuinfo: print info for all CPUs").
> 
> I've applied this on our devel branch, with a view to queuing it for -next
> in a week or two. I think we should also CC stable on this, so could you
> see how far back it applies please? (note that I already had to resolve
> a conflict with a patch we've got queued from Ard).

<dons Debian hat>

Since we'll be shipping 3.16 in our next release I'd love to see it go
back at least as far as that ;-)

(I'd likely apply it myself even if it doesn't appear via stable).

Ian.

