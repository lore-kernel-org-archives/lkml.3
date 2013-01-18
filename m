Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3ARAXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:23:53 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51918 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3ARAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:23:52 -0500
Date: Thu, 17 Jan 2013 16:23:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Message-ID: <20130118002347.GB3959@kroah.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358469577-8794-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 04:39:37PM -0800, K. Y. Srinivasan wrote:
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

No changelog entry describing the patch?

> ---
>  arch/x86/include/asm/irq_vectors.h |    2 +
>  arch/x86/include/asm/mshyperv.h    |    4 +++
>  arch/x86/kernel/cpu/mshyperv.c     |   39 ++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/entry_32.S         |    7 ++++++
>  arch/x86/kernel/entry_64.S         |    5 ++++
>  5 files changed, 57 insertions(+), 0 deletions(-)

This patch needs to go through the x86 maintainers, which you didn't
include all of on the To: line, any reason why?

greg k-h
