Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3HLKEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:04:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:43354 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3HLKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:04:50 -0400
Date: Mon, 12 Aug 2013 12:04:49 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] arm: spear: platsmp: fix lock definition
Message-ID: <20130812100449.GB23040@linutronix.de>
References: <1375365264-10135-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375365264-10135-1-git-send-email-balbi@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi | 2013-08-01 16:54:24 [+0300]:
>
>compile tested only, I don't have any spear boards.
>
>But at least solves the argument error compile warnings.

looks very correct :) Applied and folded back into the original patch.

Sebastian
