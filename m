Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3DLFft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:35:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52008 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3DLFft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:35:49 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130412053234.GB3887@gmail.com>
References: <20130410110840.GA29752@gmail.com> <20130410122411.GE13394@pd.tnic> <20130410122527.GB8686@gmail.com> <20130410133251.GC6857@pd.tnic> <516586CF.90909@zytor.com> <20130410161122.GI6857@pd.tnic> <20130410212950.GA6899@pd.tnic> <20130411120952.GA18879@gmail.com> <51670E51.6020106@zytor.com> <20130411202328.GA15955@pd.tnic> <20130412053234.GB3887@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 11 Apr 2013 22:34:48 -0700
To: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Message-ID: <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used to have one of these but have it away when cleaning out my study... no space.

Ingo Molnar <mingo@kernel.org> wrote:

>
>* Borislav Petkov <bp@alien8.de> wrote:
>
>> On Thu, Apr 11, 2013 at 12:26:09PM -0700, H. Peter Anvin wrote:
>> > What host is this?
>> 
>> Judging by the DMI string in the oops:
>> 
>> > [   15.921486] Pid: 73, comm: hwclock Tainted: G        W   
>3.9.0-rc6+ #222032 System manufacturer System Product Name/A8N-E
>> 
>> it is an ASUS board with a K8 on it - probably Ingo's old K8 which
>> triggers all kinds of crap off an on.
>> 
>> 8-)
>
>Yep, with Fedora Core 8, and totally unchanged userspace, booting
>randconfigs of 
>the latest -tip:master tree. This box has booted up over a million
>Linux kernels 
>in the past 4+ years, so when it shows new types of sickness then in
>99.9% of the 
>cases it's something about the kernel.
>
>The lockup went away after excluding x86/cpu. I'll try more testing as
>time 
>permits.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
