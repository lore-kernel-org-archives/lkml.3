Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab3JNVGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:06:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585Ab3JNVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:06:17 -0400
Date: Mon, 14 Oct 2013 14:06:16 -0700
From: greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: ARC fixes backport for stable 3.10
Message-ID: <20131014210616.GB12262@kroah.com>
References: <525BA41B.4000109@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525BA41B.4000109@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 01:28:19PM +0530, Vineet Gupta wrote:
> 7efd0da2d173 ARC: Fix __udelay calculation
> c11eb222fd7d ARC: Handle zero-overhead-loop in unaligned access handler
> 0752adfda15f ARC: Fix 32-bit wrap around in access_ok()
> 6c00350b573c ARC: Workaround spinlock livelock in SMP SystemC simulation
> 10469350e345 ARC: Fix signal frame management for SA_SIGINFO
> 5b24282846c0 ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

All applied, thanks.

greg k-h
