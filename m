Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaBYS4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:56:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:39068 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaBYS4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:56:23 -0500
Date: Tue, 25 Feb 2014 19:56:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        metag <linux-metag@vger.kernel.org>
Subject: Re: [patch 06/26] metag: Use irq_set_affinity instead of homebrewn
 code
In-Reply-To: <alpine.DEB.2.02.1402241432360.21251@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1402251955390.21251@ionos.tec.linutronix.de>
References: <20140223212703.511977310@linutronix.de> <20140223212736.887575774@linutronix.de> <530B47FD.80608@imgtec.com> <alpine.DEB.2.02.1402241432360.21251@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Thomas Gleixner wrote:
> On Mon, 24 Feb 2014, James Hogan wrote:
> Delta patch below.

Does that fix your issue?

Thanks,

	tglx
