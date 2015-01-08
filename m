Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbbAHRgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:36:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58194 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbbAHRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:36:09 -0500
Date: Thu, 8 Jan 2015 17:36:00 +0000
From: Will Deacon <will.deacon@arm.com>
To: Pratyush Anand <panand@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tixy@linaro.org" <tixy@linaro.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "wcohen@redhat.com" <wcohen@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>
Subject: Re: [RFC 2/8] ARM64: Refactor kprobes-arm64
Message-ID: <20150108173600.GW11583@arm.com>
References: <cover.1420038188.git.panand@redhat.com>
 <9a86c217f387f45568c18b724024b0d3e040d2c6.1420038188.git.panand@redhat.com>
 <20150108165557.GQ11583@arm.com>
 <54AEBF54.7000704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AEBF54.7000704@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 05:33:08PM +0000, Pratyush Anand wrote:
> On Thursday 08 January 2015 10:25 PM, Will Deacon wrote:
> > On Wed, Dec 31, 2014 at 03:21:18PM +0000, Pratyush Anand wrote:
> >> Most of the stuff of kprobes-arm64.c can also be used by uprobes.c. So
> >> move all those part to common code area. In the process rename kprobe to
> >> probe whereever possible.
> >>
> >> No functional change.
> >
> > In which case, can you merge this into the kprobes series (which we haven't
> > merged yet)?
> >
> 
> Yes, thats why these are just RFCs. I will send next version of uprobe 
> only after kprobe patches are accepted into maintainer's tree.

Ok, but it also makes sense to make kprobes refactoring changes *before* the
patches are merged, as that reduces churn in mainline whilst you don't have
any other dependencies.

Will
