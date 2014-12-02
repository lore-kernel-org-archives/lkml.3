Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbaLBWSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:18:53 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42533 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbaLBWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:18:52 -0500
Message-ID: <547e3aca.0ca5e00a.3c72.68f6@mx.google.com>
Date: Tue, 2 Dec 2014 20:18:46 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141202221031.GX25340@linux.vnet.ibm.com>
References: <20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<20141202221031.GX25340@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 14:10:31 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Thank you!!!

	;)

> Was this as difficult to trigger as the version with the Kconfig hack
> that used CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n?

	Yes. I had to try many times until I got the call trace.

	I'll try the bisect as Linus suggested, but if you have any
other suggestions, just ask ;). Thanks Paul.

-- 
Linux 3.17.0-dirty: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
