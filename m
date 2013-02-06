Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab3BFTNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:13:17 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:51844 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3BFTNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:13:16 -0500
Date: Wed, 6 Feb 2013 11:13:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, JBeulich@suse.com, bp@alien8.de
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Message-ID: <20130206191313.GA1470@kroah.com>
References: <1360164359-12273-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360164359-12273-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 07:25:59AM -0800, K. Y. Srinivasan wrote:
> Use the infrastructure for delivering VMBUS interrupts using a
> special vector. With this patch, we can now properly handle
> the VMBUS interrupts that can be delivered on any CPU. Also,
> turn on interrupt load balancing as well.
> 
> This patch requires the infrastructure that was implemented in the patch:
> X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> 

Because of the dependancy, this should go through the x86 tree as well:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

