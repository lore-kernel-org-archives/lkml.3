Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3JaTn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:43:56 -0400
Received: from fifo99.com ([67.223.236.141]:56070 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3JaTnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:43:55 -0400
Date: Thu, 31 Oct 2013 12:43:46 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131031194346.GC31722@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
 <20131029132043.GA28165@fifo99.com>
 <CAOesGMhg8HN4Su9FXSeoAgmH6NVKXW+wmnreUvWH+1G6GWkkaA@mail.gmail.com>
 <87ob66nyqc.fsf@linaro.org>
 <20131030232412.GA10229@fifo99.com>
 <8738nhnz4s.fsf@linaro.org>
 <20131031173506.GA31722@fifo99.com>
 <20131031192330.GG16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031192330.GG16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 07:23:30PM +0000, Russell King - ARM Linux wrote:
> On Thu, Oct 31, 2013 at 10:35:06AM -0700, Daniel Walker wrote:
> > ARM and the sub-architectures is already confusing I don't think we need
> > to start compounding the problem by allowing random whatever-you-want
> > sub-directories from every sub-architecture.
> 
> Confusing?
> 
> I'm not sure about that.  It's actually really simple from my perspective:
> 
> arch/arm - the ARM 32-bit architecture
> 
> arch/arm/mach-* - support for a single SoC or a group of similar SoCs
> 
> arch/arm/plat-* - common support for a set of dissimilar SoCs which want
> 	to share code between themselves
> 
> How is that confusing?
> 

It's the relationship between the arch/arm/mach-* and the
arch/arm/plat-* and which ones connect with each other etc, and how the
connection was actually done..

For me as a developer I found it confusing vs something that was fully integrated.

Daniel

