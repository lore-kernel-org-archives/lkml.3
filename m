Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKZNXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:23:17 -0500
Received: from tundra.namei.org ([65.99.196.166]:51323 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaKZNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:23:16 -0500
Date: Thu, 27 Nov 2014 00:23:06 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PULL] seccomp update (next)
In-Reply-To: <20141125194319.GA9328@www.outflux.net>
Message-ID: <alpine.LRH.2.11.1411270022240.22560@namei.org>
References: <20141125194319.GA9328@www.outflux.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Kees Cook wrote:

> Hi,
> 
> Please pull these seccomp changes for next.
> 
> Thanks!
> 
> -Kees
> 
> The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:
> 
>   Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/seccomp-next
> 
> for you to fetch changes up to cb24de187b9a0717246f05afc0f2be070e075d80:
> 
>   seccomp: Replace smp_read_barrier_depends() with lockless_dereference() (2014-11-25 11:40:24 -0800)
> 
> ----------------------------------------------------------------
> Improves SMP dereferencing with new macro.
> 
> ----------------------------------------------------------------
> Pranith Kumar (1):
>       seccomp: Replace smp_read_barrier_depends() with lockless_dereference()
> 
>  kernel/seccomp.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 

This is what I get when pulling to my next branch:

9128 files changed, 468773 insertions(+), 340317 deletions(-)


-- 
James Morris
<jmorris@namei.org>

