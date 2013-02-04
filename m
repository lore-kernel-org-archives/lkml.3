Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3BDRQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:16:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:44946 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3BDRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:16:07 -0500
Date: Mon, 4 Feb 2013 18:16:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Clark Williams <williams@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt26
In-Reply-To: <20130204105900.63bd5fae@riff.lan>
Message-ID: <alpine.LFD.2.02.1302041812460.11905@ionos>
References: <alpine.LFD.2.02.1302041537230.11905@ionos> <20130204095438.41376edb@riff.lan> <20130204105900.63bd5fae@riff.lan>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Clark Williams wrote:
> More changes; I was running into a collision with the name kmap_prot.

Bah. I knew that I should have decided that today is still part of the
weekend.

Pushed out rt27 with the fixed merged back. Sorry for the noise.

Thanks,

	tglx
