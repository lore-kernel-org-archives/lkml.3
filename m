Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3LREBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:01:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LREBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:01:07 -0500
Message-ID: <1387339256.5315.12.camel@marge.simpson.net>
Subject: Re: question about cpu_active_mask
From: Mike Galbraith <bitbucket@online.de>
To: markh@compro.net
Cc: linux-kernel@vger.kernel.org
Date: Wed, 18 Dec 2013 05:00:56 +0100
In-Reply-To: <52B0BBBD.3000704@compro.net>
References: <52B0BBBD.3000704@compro.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:kjTMkPpV8X0j6vq3aKt1+Z55oRQWLEPvkhLAfq5UPnw
 6W0nGjbfo/ScIY7OPWSueRssDarO00i5PxgxAEmO1WGW/agiMF
 iK7ekTbgakqwjD9mUeSCV17ozCqMSpu+6GGQ1pr2TyTMa48cDu
 xzeCXfodZrcxwb1NEOL1hoIlgNS8O07ZKiij6riNp4obBStDWT
 QF0rVF1DA+NmOMfF0oDWrEClJgdlyNp3ndCAaNXk/C7eL/UTR2
 FGqWiHDAuCy/IPzOq0IKzZr7MbT63+YEwyEkJZ/rTfBHqFhqSK
 9QeDqRWPJJqty8/NPvZeUArrLANL01PoPmnIjVjqAjglf32/wM
 aeRZVCpqfHOochgFj/kUu+boLZPwsGEBAsY9cnWtHT4Y5dRx3k
 bqcZVJcjqcBNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 16:01 -0500, Mark Hounschell wrote: 
> I hope it is OK to ask a newbie question here. I'm trying to better 
> understand the boot process. I can't seem to find where in the kernel 
> sources the cpu_active_mask (defined in include/linux/cpumask.h) gets 
> populated. I can see that it does get populated as it brings cpus online 
> but it is not obvious to me where. I'm using a 32 bit 3.4.x flavor kernel.

Try git grep set_cpu_active.

-Mike

