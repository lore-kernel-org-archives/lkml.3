Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaAMKDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:03:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:39644 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaAMKDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:03:37 -0500
Date: Mon, 13 Jan 2014 11:03:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <davidlohr@hp.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Subject: Re: [PATCH v6 0/5] futex: Wakeup optimizations
In-Reply-To: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
Message-ID: <alpine.DEB.2.02.1401131102410.4578@ionos.tec.linutronix.de>
References: <1389569486-25487-1-git-send-email-davidlohr@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jan 2014, Davidlohr Bueso wrote:

For the whole series:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
