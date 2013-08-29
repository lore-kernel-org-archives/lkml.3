Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab3H2SZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:25:35 -0400
Received: from mout.gmx.net ([212.227.17.20]:59884 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab3H2SZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:25:33 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: llvmlinux@lists.linuxfoundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, pageexec@freemail.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 20:23:55 +0200
Message-ID: <2571698.tomcdIIDB2@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
In-Reply-To: <521F9076.1050405@zytor.com>
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de> <3804425.88935NyK6A@aragorn.auenland.lan> <521F9076.1050405@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:F9nzdycd2c8hTAtGF8kB3PCPn0BlLmTindUdLVI0ri3ZLCwarP8
 cIxbiZ0ypJgjeaPtfksS3yvwgMRcCRQU2bvH6zm1GSxca+NusuZUKsJhFwCaafVbmpWnyXj
 tEnM7vaZG7P391zhxqJs7dDuDiYCGo437s66FYEqHskGZblXKNHMO1easJMqeyW3fzrf2j0
 rISrqr0n+Qm90aSqNZaOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Actually, it might be a bad idea.  In C embedded assembly we sometimes
> need %% and sometimes %.

You speak of arch/x86/kvm/vmx.c, right ?


