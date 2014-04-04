Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaDDIAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:00:16 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46179 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaDDIAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:00:10 -0400
Date: Fri, 4 Apr 2014 10:00:07 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, aubrey.li@linux.intel.com, rostedt@goodmis.org,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
Message-ID: <20140404080006.GB6944@gmail.com>
References: <20140404064120.GB11877@gmail.com>
 <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Ingo Molnar <tipbot@zytor.com> wrote:

> Commit-ID:  d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
> Gitweb:     http://git.kernel.org/tip/d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3
> Author:     Ingo Molnar <mingo@kernel.org>
> AuthorDate: Fri, 4 Apr 2014 08:41:26 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 4 Apr 2014 08:48:03 +0200
> 
> [PATCH] x86: Try the BIOS reboot method before the PCI reboot method

So, JFYI, I have put this into x86/reboot to get it tested, but it's 
not queued up for upstream yet until there's concensus.

(Steve testing it wouldn't hurt either.)

Thanks,

	Ingo
