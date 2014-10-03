Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaJCKdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:33:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:46431 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaJCKdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:33:07 -0400
Date: Fri, 3 Oct 2014 12:33:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
Message-ID: <alpine.DEB.2.11.1410031231420.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014, Christoph Lameter wrote:

The answer is simply that nobody cared so far.
 
> Is this the way its intended or should the counters be expanded to 64 bit?

There is no reason why we cannot or should not expand them.

Thanks,

	tglx
