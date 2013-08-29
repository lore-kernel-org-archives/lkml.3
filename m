Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3H2SNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:13:38 -0400
Received: from mout.gmx.net ([212.227.17.22]:60227 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456Ab3H2SNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:13:36 -0400
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: llvmlinux@lists.linuxfoundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, pageexec@freemail.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH] [RFC] [X86] Fix a compilation issue with clang.
Date: Thu, 29 Aug 2013 20:11:59 +0200
Message-ID: <3804425.88935NyK6A@aragorn.auenland.lan>
User-Agent: KMail/4.11 (Linux/3.7.10-1.16-default; KDE/4.11.0; x86_64; ; )
In-Reply-To: <521F8ED4.2080009@zytor.com>
References: <1377796428-12719-1-git-send-email-dl9pf@gmx.de> <6320951.e8eKRZ5b9s@aragorn.auenland.lan> <521F8ED4.2080009@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:e/+YWm7vYHgw3W9BIg+MHHUZpeo1bZHuqW05FYFnM4PBvmMR9Bn
 b+8AnFUMuXToJIKvH+xp6GFCVOtdgK0snjznNvzKE+j6xqhKfPykmQ2EXvVIXa322bSGVsl
 bL34HyFEwlywP3+s8WqcqPu8Hn1ZK25+kQBltOamLfZGeWpIUDs2zPPS9lHq/CZH188FgbE
 SaqF6Ct73KBfS7Zjx+pAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 August 2013 11:11:32 H. Peter Anvin wrote:
> On 08/29/2013 11:00 AM, Jan-Simon Möller wrote:
> >> You just changed the sematics of the _ASM_* macros... that doesn't seem
> >> like a great idea.  It's probably okay for the registers, but still...
> > 
> > Well, we followed your idea for the _ASM_DX macros as you mentioned them
> > earlier.
> 
> We can probably do this, because register names are usually not assumed
> to have spaces around them... so it's probably okay.  Definitely a lot
> less ugly than the rest.  That being said, if we're going to fix these
> macros, we should also fix another piece of drain bramage:
> 
> ALL instances of these have a % prepended.  The % should be part of the
> macro.

Ok, I can make a follow-up patch for the above change. Give me a bit to cook 
it up.

Best,
JS


