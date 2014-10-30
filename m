Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbaJ3RP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:15:29 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:51102 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054AbaJ3RP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:15:28 -0400
Date: Thu, 30 Oct 2014 17:15:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "ghackmann@google.com" <ghackmann@google.com>,
        "ijc@hellion.org.uk" <ijc@hellion.org.uk>,
        Serban Constantinescu <Serban.Constantinescu@arm.com>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] arm64: Fix up /proc/cpuinfo
Message-ID: <20141030171521.GL32589@arm.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
 <1414159000-27059-2-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414159000-27059-2-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Oct 24, 2014 at 02:56:40PM +0100, Mark Rutland wrote:
> Commit d7a49086f263164a (arm64: cpuinfo: print info for all CPUs)
> attempted to clean up /proc/cpuinfo, but due to concerns regarding
> further changes was reverted in commit 5e39977edf6500fd (Revert "arm64:
> cpuinfo: print info for all CPUs").

I've applied this on our devel branch, with a view to queuing it for -next
in a week or two. I think we should also CC stable on this, so could you
see how far back it applies please? (note that I already had to resolve
a conflict with a patch we've got queued from Ard).

Cheers,

Will
