Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3EAXUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:20:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab3EAXT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:19:58 -0400
Date: Wed, 1 May 2013 10:19:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH -v2.1] x86: Add a Kconfig shortcut for kvm guest kernel
Message-ID: <20130501131924.GB14215@amt.cnet>
References: <516A7760.7030907@kernel.org>
 <20130414110320.GB20547@pd.tnic>
 <20130416161852.GH5332@pd.tnic>
 <20130417232507.GC31059@amt.cnet>
 <20130418094629.GC21719@pd.tnic>
 <20130418133631.GA30965@amt.cnet>
 <20130419103519.GB21981@pd.tnic>
 <20130426000553.GE32607@pd.tnic>
 <20130426064250.GA31064@gmail.com>
 <20130426095140.GA15361@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426095140.GA15361@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:51:40AM +0200, Borislav Petkov wrote:
> On Fri, Apr 26, 2013 at 08:42:50AM +0200, Ingo Molnar wrote:
> >
> > ... < take all review comments >
> 
> Here it is:
> 
> --
> >From 56880e448600ca1504df8c68c59f31153f7b5b0f Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Tue, 16 Apr 2013 18:24:34 +0200
> Subject: [PATCH -v2.1] x86: Add a Kconfig shortcut for kvm guest kernel
> 
> This is pretty useful for the case where people want to boot the
> resulting kernel in qemu/kvm or lkvm. Instead of going and searching for
> each required option through the Kconfig maze, this single option should
> simply enable everything required/good to have to boot the resulting
> kernel in the guest.
> 
> Patch has been adapted from a version in the external lkvm tree.
> 
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Originally-by: Pekka Enberg <penberg@kernel.org>
> Originally-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/Kconfig | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)

Applied, thanks.

