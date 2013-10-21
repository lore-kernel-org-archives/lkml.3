Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3JUOVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:21:07 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33541 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3JUOVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:21:03 -0400
Message-ID: <52653847.1050606@gmail.com>
Date: Mon, 21 Oct 2013 10:20:55 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Linux Torvalds <torvalds@osdl.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2] x86: add kconfig options for newer 64-bit processors
References: <526325C9.7030705@gmail.com> <20131020091813.GA4972@pd.tnic> <52646E0E.6040204@gmail.com> <20131021105401.GA5019@nazgul.tnic> <526513B5.5050203@gmail.com> <20131021135917.GA6117@nazgul.tnic>
In-Reply-To: <20131021135917.GA6117@nazgul.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-21 09:59, Borislav Petkov wrote:
> 
> This doesn't really make much sense because the single biggest
> build target is distros with a single system image which is
> supposed to run as optimally as possible on any x86 hardware.
> 
> So specialized builds are only for Gentoo users and others who
> build customized kernels. And those who can do that, can also apply
> this patch to their own tree.
> 
By this same logic though, none of the x86 processor tuning options
currently in the kernel should have been put in in the first place
(and, taking it to an extreme, should in fact be removed).
