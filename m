Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3GAIUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:20:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:53526 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3GAIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:20:45 -0400
Date: Mon, 1 Jul 2013 10:20:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktime: add missing declaration of ktime_get() in
 ktime.h
In-Reply-To: <1372657995-10903-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.02.1307011020260.4013@ionos.tec.linutronix.de>
References: <1372657995-10903-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Joonsoo Kim wrote:

> We cannot use ktime_get() API even if we include ktime.h, because there is
> no declaration of this API in ktime.h. So add it.

It's declared in hrtimer.h

Thanks,

	tglx
