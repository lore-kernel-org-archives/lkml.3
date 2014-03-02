Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaCBKqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 05:46:10 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57725 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaCBKqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 05:46:08 -0500
Date: Sun, 2 Mar 2014 11:46:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: [PATCH v21 12/12] x86: Zero-pad the VVAR page
Message-ID: <20140302104603.GA18257@gmail.com>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net>
 <1393752020-6740-13-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393752020-6740-13-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefani Seibold <stefani@seibold.net> wrote:

> By coincidence, the VVAR page is at the end of an ELF segment.  As a
> result, if it ends up being a partial page, the kernel loader will
> leave garbage behind at the end of the vvar page.  Zero-pad it to a
> full page to fix this issue.
> 
> This has probably been broken since the VVAR page was introduced.
> On QEMU, if you dump the run-time contents of the VVAR page, you can
> find entertaining strings from seabios left behind.
> 
> It's remotely possible that this is a security bug -- conceivably
> there's some BIOS out there that leaves something sensitive in the
> few K of memory that is exposed to userspace.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>

That's not a valid signoff sequence - if the patch came from Andy then 
the patch needs to contain a From: Andy line as well. If Andy acked or 
reviewed the patch then please add an Acked-by or Reviewed-by line.

Thanks,

	Ingo
