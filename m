Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3EMJVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:21:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:46671 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3EMJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:21:04 -0400
Date: Mon, 13 May 2013 11:21:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robin Holt <holt@sgi.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Full dynticks needs evtdesc set before marking cpu online.
In-Reply-To: <20130508235736.GT3658@sgi.com>
Message-ID: <alpine.LFD.2.02.1305131119180.2863@ionos>
References: <20130508235736.GT3658@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Robin Holt wrote:

> Thomas,
> 
> We are seeing failures booting medium sized machines which I think is
> a change in expectations that dyntick put on x86's start_secondary.
> 
> During boot of cpus, we see an occassional panic in tick_do_broadcast at

http://lkml.indiana.edu/hypermail/linux/kernel/1305.0/01818.html

Will hit Linus tree soon.

Thanks,

	tglx
