Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3FJPS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:18:59 -0400
Received: from blackhole.sdinet.de ([176.9.52.58]:52751 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab3FJPS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:18:58 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 11:18:57 EDT
Date: Mon, 10 Jun 2013 17:11:49 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Willy Tarreau <w@1wt.eu>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.61
In-Reply-To: <20130610101557.GA3235@1wt.eu>
Message-ID: <alpine.DEB.2.10.1306101708360.1713@aurora64.sdinet.de>
References: <20130610101557.GA3235@1wt.eu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, Willy Tarreau wrote:

> Willy Tarreau (2):
>       x86, ptrace: fix build breakage with gcc 4.7

This change breaks "make headers_install":

  CHECK   include (0 files)
  CHECK   include/asm (54 files)
/home/haegar/src/2.6.32/linux/usr/include/asm/ptrace.h:5: included file 'linux/linkage.h' is not exported
make[3]: *** [/home/haegar/src/2.6.32/linux/usr/include/asm/.check] Error 123
make[2]: *** [headers_check] Error 2
make[1]: *** [deb-pkg] Error 2
make: *** [deb-pkg] Error 2

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
