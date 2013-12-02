Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3LBN6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:58:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:44663 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LBN6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:58:15 -0500
Date: Mon, 2 Dec 2013 14:58:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clocksource: zevio-timer: fix incorrect function
 definition so the correct function pointer is passed to
 CLOCKSOURCE_OF_DECLARE
In-Reply-To: <alpine.LNX.2.00.1312021453490.24931@pobox.suse.cz>
Message-ID: <alpine.DEB.2.02.1312021457020.30673@ionos.tec.linutronix.de>
References: <1385353764-88784-1-git-send-email-dt.tangr@gmail.com> <alpine.LNX.2.00.1312021453490.24931@pobox.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Jiri Kosina wrote:

> On Mon, 25 Nov 2013, dt.tangr@gmail.com wrote:
> 
> > From: Daniel Tang <dt.tangr@gmail.com>
> > 
> 
> This really needs a proper changelog.

Along with a proper subject line. Subject lines should give a quick
scope of the patch. The detailed explanation has to be in the
changelog itself.

Thanks,

	tglx
