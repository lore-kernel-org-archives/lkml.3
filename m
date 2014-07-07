Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaGGWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:05:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaGGWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:05:24 -0400
Date: Mon, 7 Jul 2014 15:05:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] checkstack: use $UTS_MACHINE as target architecture
Message-Id: <20140707150523.cc671116bf366e8db73209c5@linux-foundation.org>
In-Reply-To: <20140705112238.16142.42735.stgit@zurg>
References: <20140705112238.16142.42735.stgit@zurg>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2014 15:22:38 +0400 Konstantin Khlebnikov <koct9i@gmail.com> wrote:

> This fixes command # make checkstack for i386/x86_64.
> Looks like $UTS_MACHINE is exactly what scripts/checkstack.pl needs.
> 
> By default $UTS_MACHINE is equal to $ARCH, but some arch/${ARCH}/Makefile
> overrides it. This patch updates it also in arch/x86/Makefile.um
> 
> broken in ffee0de ("x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT")

The changelog doesn't describe the bug which is being fixed.  It should
do so please.  If there are any compiler/make error messages then those
should be included.

