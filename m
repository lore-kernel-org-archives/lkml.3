Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbbA1Uds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:33:48 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:62315 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbbA1Udp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:33:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smack: fix netfilter Makefile entry
Date: Wed, 28 Jan 2015 20:23:27 +0100
Message-ID: <30287261.Lan5Co1lCn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54C927E3.6000006@cogentembedded.com>
References: <2504358.ZeqdfUXKpJ@wuerfel> <54C927E3.6000006@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:A4j/URI7HAOJon8+LzohRXHL+XQ1iyKYWyojeCkgNZWS4I/VNiq
 3+p+RPTA9Hx3OUx31zwHBrinBVavwnFU4ieBXmcpuYP4YjXaZpe2Sjb4pjO5bYvPkL2okXu
 kS4AnYFyr4oSAwwz7HrIJTIK+JDavjm+Fu2CjJGpL5PIpdZY8HaKFSDl9/v6XerD628ZeZJ
 Ulyodebd1d++ztoxSSEtQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 21:18:11 Sergei Shtylyov wrote:
> > diff --git a/security/smack/Makefile b/security/smack/Makefile
> > index 616cf93b368e..d4a376c84050 100644
> > --- a/security/smack/Makefile
> > +++ b/security/smack/Makefile
> > @@ -5,4 +5,4 @@
> >   obj-$(CONFIG_SECURITY_SMACK) := smack.o
> >
> >   smack-y := smack_lsm.o smack_access.o smackfs.o
> > -smack-$(CONFIG_NETFILTER) += smack_netfilter.o
> > +smack-$(SECURITY_SMACK_NETFILTER) += smack_netfilter.o
> 
>     CONFIG_ missing?

Yes, you are right. Anyway, as another fix is already queued,
it doesn't matter any more.

	Arnd
