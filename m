Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaAPTdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:33:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43748 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbaAPTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:33:06 -0500
Date: Thu, 16 Jan 2014 19:32:29 +0000
From: Will Deacon <will.deacon@arm.com>
To: Kyle McMartin <kyle@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] aarch64: always map VDSO at worst case alignment
Message-ID: <20140116193229.GC22105@mudshark.cambridge.arm.com>
References: <20140115214144.GF18705@redacted.bos.redhat.com>
 <20140116174344.GJ30257@mudshark.cambridge.arm.com>
 <20140116175318.GK18705@redacted.bos.redhat.com>
 <20140116192841.GN18705@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116192841.GN18705@redacted.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 07:28:42PM +0000, Kyle McMartin wrote:
> On Thu, Jan 16, 2014 at 12:53:18PM -0500, Kyle McMartin wrote:
> > I'll reboot a machine with this fix to test it as soon as possible.
> > 
> > Acked-by: Kyle McMartin <kyle@redhat.com>
> > 
> 
> Yeah, looks to work properly, although I didn't test 64K pages in the
> simulator.

No problem. I did try testing 64k pages in the simulator, and found that
earlyprintk is broken (now fixed).

Cheers,

Will
