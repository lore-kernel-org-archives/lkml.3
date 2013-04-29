Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819Ab3D2Tie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:38:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:57696 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab3D2TiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:38:00 -0400
Date: Mon, 29 Apr 2013 21:37:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Carsten Emde <C.Emde@osadl.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Subject: Re: [ANNOUNCE] 3.8.9-rt4
Message-ID: <20130429193758.GA7979@linutronix.de>
References: <20130426222001.GH20927@linutronix.de>
 <517C46D6.7030601@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <517C46D6.7030601@osadl.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Carsten Emde | 2013-04-27 23:44:54 [+0200]:

>Hi Sebastian,
Hi Carsten,

>This patch is needed to prevent the compiler error
>drivers/gpu/drm/i915/i915_gem_execbuffer.c:1072:27:
>error: 'seqno' undeclared (first use in this function)

thanks, I folded it into the patch that broke it.

Sebastian
