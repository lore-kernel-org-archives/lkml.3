Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3JDME2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:04:28 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54664 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751678Ab3JDME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:04:26 -0400
Date: Fri, 4 Oct 2013 13:03:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: Use of drivers/platform and matching include?
Message-ID: <20131004120324.GE25137@arm.com>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org>
 <CAOesGMjJ6Uj0uGFJqtnWQyDW+tr6eLVWoHZ+B7uFna+L8N6E8Q@mail.gmail.com>
 <20131003170914.GA11992@kroah.com>
 <20131004114340.GM12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004114340.GM12758@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 12:43:40PM +0100, Russell King - ARM Linux wrote:
> On Thu, Oct 03, 2013 at 10:09:14AM -0700, Greg Kroah-Hartman wrote:
> > On Thu, Oct 03, 2013 at 09:46:30AM -0700, Olof Johansson wrote:
> > > I don't have a good answer though. If it wasn't for the arm64 fork,
> > > locating these under arch/arm somewhere would really be the reasonable
> > > answer, like we used to do on powerpc. :(
> > 
> > Sounds like yet-another-good reason why there shouldn't be an arm64
> > "fork" at all :(
> > 
> > The arm community created this mess, you all can fix it up, it's not too
> > late.
> 
> I said at the time, way before arm64 was merged that it should not be a
> separate arch.  Every bit of feedback I gave on arm64 got shouted down
> by Catalin.  ARM64 is Catalin's baby and he wants to protect it at all
> costs.

My counter arguments weren't probably clear to you. I want to protect a
clean, legacy-free AArch64 implementation at all costs.

-- 
Catalin
