Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaIVTAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:00:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:49960 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaIVTAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:00:02 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH v8] tpm_tis: verify interrupt during init
Date: Mon, 22 Sep 2014 21:01:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
Cc: Scot Doyle <lkml14@scotdoyle.com>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1409110010290.700@localhost.localdomain> <20140922171338.GB28082@obsidianresearch.com>
In-Reply-To: <20140922171338.GB28082@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409222101.19297.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:E8NrVaNw6E00X6UTmc++APbFh4d554h50KoV3FFlc+prRPx38fO
 AF1DXn8gOqolkgopk6hTgUiUNSrjo8xwZsEwP2En2RYLWX/2zPRqMFPxoFemkhCZ0Hpy15T
 Fywt4NVP06STZQ1q0rb1iK3naUICSNAv6g1NduCD62K+AMX4Zkoa+X5uWfbuz4vy5+L1FsN
 onbImKVwoNL7+KrC9FLhg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. September 2014, 19:13:38 schrieb Jason Gunthorpe:

> 
> This does look much nicer, lets use this version.
> 
> I think Peter were prefer a new clean patch that superceeds the
> original.
> 
> > +	if (!priv->irq_tested) {
> 
> I think the sleep and check is still needed here, the IRQ delivery
> could race relative to the MMIO read of completion, a sleep is the
> only way we could attempt to synchronize them..
> 

So will there be a v9?

Merge Window is coming up shortly, so I would like to have this sorted out 
soon ;)

Thanks,
Peter
