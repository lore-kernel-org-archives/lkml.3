Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaL0QZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 11:25:21 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:49265 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaL0QZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 11:25:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141226165401.GH11609@linux.vnet.ibm.com>
References: <20141226185120.402d392f@canb.auug.org.au> <20141226165401.GH11609@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sat, 27 Dec 2014 11:24:43 -0500
Message-ID: <CAJhHMCCErUVzD_9mYZOVo=Z_FuBQVV53XWMX_SMEfVUZmBEcRQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the rcu tree
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 11:54 AM, Paul E. McKenney wrote:
> Pranith, if Stephen has CONFIG_KVM=n, it might be best to move the
> "select SRCU" to "config PPC" in arch/powerpc/Kconfig.  Are you able
> to cross-build powerpc?
>

ppc 32 seems fine without selecting srcu unconditionally. So I added
this select to PPC 64 which should fix this build failure.

I will send the updated patch once I've done some basic tests. Sorry
for the delay!

-- 
Pranith
