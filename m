Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3JYK5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:57:47 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:59808 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3JYK5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:57:45 -0400
Date: Fri, 25 Oct 2013 12:57:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/apic: Disable I/O APIC before shutdown local APIC
Message-ID: <20131025105742.GA5485@gmail.com>
References: <1382578212-4677-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382578212-4677-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> In reboot and crash path, when shutdown local APIC, I/O APIC is still active.
> This may cause issues because external interrupts can still come in and
> disturb local APIC during shutdown process. To quiet external interrupts,
> disable I/O APIC before shutdown local APIC.

What specific 'issues' were observed, on what kind of systems?

Thanks,

	Ingo
