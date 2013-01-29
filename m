Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3A2Vc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:32:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:48194 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A2Vc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:32:56 -0500
Message-ID: <51084005.2050506@linutronix.de>
Date: Tue, 29 Jan 2013 22:32:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: jlmales@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Failure - 3.4.24
References: <20130116184221.aaa9e2aa.jlmales@gmail.com> <51055256.6030602@linutronix.de> <20130128145708.3c241dc8.jlmales@gmail.com>
In-Reply-To: <20130128145708.3c241dc8.jlmales@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 08:57 PM, John L. Males wrote:
> I was not suggesting you are responsible for the bug at all. On
Okay then :)

> I have no custom patches to the kernel.
okay.

> I looked at the RedHat bug 468794.  The bug seems to indicate it
> was never fixed.  The bug was reported against 
> 2.6.27.4-47.rc3.fc10.i686 #1 on 2008-10-27 21:34:04 EDT and was
> closed 2009-12-18 01:40:33 EST.  The differences are a bug of at
> least 5 years ago and a 2.6 kernel verses 5 years later and current
> at time stable kernel 3.4.24 from kernel.org with no patches I
> applied when this kernel failure I encountered occurred.  If this
> is the same bug then there is a bug that may have been about for a
> while or perhaps a regression.  The fact is the RedHat bug 468794
> was never fixed.

Lets see. According to the backtrace it seems that the kernel was not
able to write the buffer back to disk. The RH bug says that someone
unplugged the device without an unmount of the disk.

My question are:
- what were you doing by the time this happened?
- can you reproduce it (reliably)?
- Is this *new* meaning is there a kernel where did not happen?

Sebastian
