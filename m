Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaKCToO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:44:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:55155 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKCToL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:44:11 -0500
Date: Mon, 3 Nov 2014 20:44:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kthread: Fix the race condition when kthread is parked
In-Reply-To: <54561D2F.9000100@numascale.com>
Message-ID: <alpine.DEB.2.11.1411032041540.5308@nanos>
References: <54561D2F.9000100@numascale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2014, Daniel J Blueman wrote:
> I just got a window to test this, and it reliably addresses the boot-time core
> onlining race that we've seen occasionally on a 2000-core customer system.
> Splendid work, Thomas.
> 
> Tested-by: Daniel J Blueman <daniel@numascale.com>

Well, you forgot to read my follow up mail on this:

      https://lkml.org/lkml/2014/6/26/554

Thanks,

	tglx
