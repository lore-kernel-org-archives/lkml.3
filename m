Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaBDSzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:55:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:48540 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbaBDSzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:55:31 -0500
Date: Tue, 4 Feb 2014 19:55:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kamble, Nitin A" <nitin.a.kamble@intel.com>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: fix a Kconfig dependency
In-Reply-To: <52F12406.4020405@intel.com>
Message-ID: <alpine.DEB.2.02.1402041954350.24986@ionos.tec.linutronix.de>
References: <1391129410-54548-1-git-send-email-nitin.a.kamble@intel.com> <1391129410-54548-2-git-send-email-nitin.a.kamble@intel.com> <alpine.DEB.2.02.1401310223460.7183@chino.kir.corp.google.com> <52EBE112.5010203@intel.com> <52F12406.4020405@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014, Kamble, Nitin A wrote:
> Is there any more feedback for this fix? Currently kernel is not
> building for the affected platform without this fix. and I am happy
> to help here to get the fix pulled in sooner. Let me know.

It's in my list of stuff to apply. It'll get to Linus in a few days.

Thanks,

	tglx
