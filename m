Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3GQH6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:58:19 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41378 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3GQH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:58:18 -0400
Date: Wed, 17 Jul 2013 09:58:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Valentina Manea <valentina.manea.m@gmail.com>, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, bin.gao@linux.intel.com,
        gregkh@linuxfoundation.org, bhelgaas@google.com, x86@kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH v2] x86/pci: checkpatch.pl cleanup
Message-ID: <20130717075813.GA14629@gmail.com>
References: <1373874048-20258-1-git-send-email-valentina.manea.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373874048-20258-1-git-send-email-valentina.manea.m@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valentina Manea <valentina.manea.m@gmail.com> wrote:

> This patch fixes warning and errors found by checkpatch.pl:
> 
> * replace asm/acpi.h, asm/io.h and asm/smp.h with linux/acpi.h,
> linux/io.h and linux/smp.h respectively
> * remove explicit initialization to 0 of a static global variable
> * replace printk(KERN_INFO ...) with pr_info
> * use tabs instead of spaces for indentation
> * arrange comments so that they adhere to Documentation/CodingStyle
> 
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>

Looks good, thanks.

Bjorn, I can pick this up into tip:x86/cleanups, or would you like to put 
this into the PCI tree?

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
