Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaKJSQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:16:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:60522 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaKJSQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:16:29 -0500
Date: Mon, 10 Nov 2014 19:15:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Wu <feng.wu@intel.com>
cc: gleb@kernel.org, pbonzini@redhat.com,
        David Woodhouse <dwmw2@infradead.org>, joro@8bytes.org,
        mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: several messages
In-Reply-To: <1415600812-27773-14-git-send-email-feng.wu@intel.com>
Message-ID: <alpine.DEB.2.11.1411101913340.3935@nanos>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com> <1415600812-27773-14-git-send-email-feng.wu@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Feng Wu wrote:

> VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
> With VT-d Posted-Interrupts enabled, external interrupts from
> direct-assigned devices can be delivered to guests without VMM
> intervention when guest is running in non-root mode.

Can you please talk to Jiang and synchronize your work with his
refactoring of the x86 interrupt handling subsystem.

I want this stuff cleaned up first before we add new stuff to it.

Thanks,

	tglx
