Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3H2SCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:02:04 -0400
Received: from mout.gmx.net ([212.227.15.15]:64186 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184Ab3H2SCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:02:02 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: llvmlinux@lists.linuxfoundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, pageexec@freemail.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 20:00:24 +0200
Message-ID: <6320951.e8eKRZ5b9s@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
In-Reply-To: <521F84D4.6060108@zytor.com>
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de> <521F84D4.6060108@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:7EWIolDvv1FbvCib5oOuRHZUG59hMbsAzgRC37W7tBsaoRUmm8d
 j3LRza8hNe1ZXXo7mH4lC1Und5Rw+fJ4f+XuqHULDXTNHWB7mcGpAJWnnXgvqRL1RayMya+
 mPZihNV03CqF/lVA3YGve3qWY0khH1GQCTp3M2gC3dDrv/VzWJIsQEhI6C3PATD1ei9vm/c
 JwXrlqlfK1h9MY7p3e9nQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 August 2013 10:28:52 H. Peter Anvin wrote:
> On 08/29/2013 10:13 AM, dl9pf@gmx.de wrote:
> > From: Jan-Simon Möller <dl9pf@gmx.de>
> > 
> > Clang does not support the "shortcut" we're taking here for gcc (see
> > below).
> Read: clang is gratuitously incompatible with gcc.

Let's discuss this during the llvm track @ plumbers . 
 
> > The patch extends and uses the macro _ASM_DX to do the job.
> 
> You just changed the sematics of the _ASM_* macros... that doesn't seem
> like a great idea.  It's probably okay for the registers, but still...
> 

Well, we followed your idea for the _ASM_DX macros as you mentioned them 
earlier.

I tested this change for both clang-3.3 and gcc-4.7.2 . 

Best,
JS
