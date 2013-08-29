Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab3H2Shl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:37:41 -0400
Received: from mout.gmx.net ([212.227.15.18]:50553 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757092Ab3H2Shi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:37:38 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: llvmlinux@lists.linuxfoundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, pageexec@freemail.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 20:36 +0200
Message-ID: <1563930.LeGpPqNO9R@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
In-Reply-To: <521F9390.9030409@zytor.com>
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de> <2571698.tomcdIIDB2@aragorn.auenland.lan> <521F9390.9030409@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:l9qHA/0ZLDd8RTWRQPHEcz+Wt0YK8bKO6TofGFRRpeFWcSNgmM0
 qlWafUC0aQQ82CKPPETFs29AZudCSrrQ4b5naBAyN5KgjLHpbRafIiVcroA/LVUGz8ciRN6
 VQudYlRr3zZZdRQ5/M2bOu6aEOC37btTzeK0csnTOFiAh8gCuHy8h7/GW4b0CoJKse39p1R
 J664s9vrHZG3VsPJgnLGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 August 2013 11:31:44 H. Peter Anvin wrote:
> On 08/29/2013 11:23 AM, Jan-Simon Möller wrote:
> >> Actually, it might be a bad idea.  In C embedded assembly we sometimes
> >> need %% and sometimes %.
> > 
> > You speak of arch/x86/kvm/vmx.c, right ?
> 
> Well, in general.

Ok, I see.  So back to the patch - can we merge it then ?

Best,
JS
