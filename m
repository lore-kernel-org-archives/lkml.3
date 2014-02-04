Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaBDUAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:00:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:49014 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaBDT76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:59:58 -0500
Date: Tue, 4 Feb 2014 21:00:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shawn Landden <shawn@churchofgit.com>
cc: criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, avagin@gmail.com,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] timerfd: show procfs fdinfo helper, and now accepts
 write()
In-Reply-To: <1391443273-2031-1-git-send-email-shawn@churchofgit.com>
Message-ID: <alpine.DEB.2.02.1402042033310.24986@ionos.tec.linutronix.de>
References: <20140203104430.GA21968@paralelels.com> <1391443273-2031-1-git-send-email-shawn@churchofgit.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Shawn Landden wrote:

> | pos:	0
> | flags:	02004002
> | clockid:	0
> | ticks:        6

This changelog is completely useless. It neither explains WHY we need
to expose that fdinfo nor WHAT the write function is supposed to do.

Aside of that the code lacks any comment and there is no documentation
for the new user ABI.

> Signed-off-by: Shawn Landden <shawn@churchofgit.com>

I'm not going to find and read the bible of the churchofgit to figure
out what this is all about.

Thanks,

	tglx
