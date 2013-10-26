Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JZVgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 17:36:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:32803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3JZVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 17:36:19 -0400
Date: Sat, 26 Oct 2013 14:36:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131026213615.GA11350@infradead.org>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
 <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
 <20131026101055.GB14949@gmail.com>
 <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75C2D580-105E-4B49-80D4-E047C1530FC2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 02:34:52PM -0700, Tony Luck wrote:
> As Chen Gong points out, drivers/acpi isn't the right place ... so if not lib/ ... then where?

A to be created drivers/efi?  There should be a lot more shared EFI code
coming sooner or later, shouldn't it?

