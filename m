Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaHADHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 23:07:52 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44707 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaHADHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 23:07:51 -0400
Date: Thu, 31 Jul 2014 20:07:46 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM/ARM64: don't enter kgdb when userspace executes a
 kgdb break instruction.
Message-ID: <20140801030746.GA26941@mew>
References: <20140730071245.GA8954@mew.web-pass.com>
 <20140730112414.GJ12239@arm.com>
 <20140731053323.GA15523@mew.web-pass.com>
 <20140731104653.GM26853@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731104653.GM26853@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Will,

On Thu, Jul 31, 2014 at 11:46:53AM +0100, Will Deacon wrote:
> I'll merge the arm64 diff I proposed. Could you repost the ARM part please?
I've just reposted it, hopefully we can get that merged in soon as well.

> I think enabling and activating kgdb by default is a pretty crazy thing to
> do, but I agree that we shouldn't allow userspace to trap into it either.
Agreed, hopefully the actual footprint of this bug isn't too large, but it's
worth fixing anyways.

> Once you repost the ARM patches, we can look at getting them merged via rmk.
> 
> Cheers,
> 
> Will

Thanks again!
Omar
