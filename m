Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbaKMMyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:54:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:46760 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbaKMMyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:54:18 -0500
Date: Thu, 13 Nov 2014 13:54:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: B_B_Singh@DELL.com
cc: bp@suse.de, stuart.w.hayes@gmail.com, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: RE: [PATCH] x86: Configure NX support earlier in setup_arch
In-Reply-To: <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
Message-ID: <alpine.DEB.2.11.1411131147070.3935@nanos>
References: <53B4B627.8060903@gmail.com> <53BC7210.1000305@gmail.com> <53BC72D8.4090705@zytor.com> <53BDE4BD.50605@gmail.com> <20140714172225.GE25120@pd.tnic> <8B2F6FFD0BD1E448853114367400A3730702007068@BLRX7MCDC203.AMER.DELL.COM>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, B_B_Singh@DELL.com wrote:
> I feel this can be a valid scenario where user wants to disable the
> memory protection (NX flag disable) for his requirement, in that
> case he will hit this issue.

It's not about feelings. If the user wants to disable NX he can do so
already via the kernel command line.

What that patch is useful for is to prevent an hard to debug boot
crash if the kernel happens to run on some wreckaged BIOS. But it's
not there to support and encourage braindamaged BIOS nonsense.

Thanks,

	tglx




