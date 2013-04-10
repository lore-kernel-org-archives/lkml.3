Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936985Ab3DJPgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:36:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936962Ab3DJPgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:36:53 -0400
Message-ID: <516586CF.90909@zytor.com>
Date: Wed, 10 Apr 2013 08:35:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] x86: FPU detection in C
References: <1365436666-9837-1-git-send-email-bp@alien8.de> <20130410110840.GA29752@gmail.com> <20130410122411.GE13394@pd.tnic> <20130410122527.GB8686@gmail.com> <20130410133251.GC6857@pd.tnic>
In-Reply-To: <20130410133251.GC6857@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 06:32 AM, Borislav Petkov wrote:
> (let's test the reply-to-all settings now :-))
> 
> On Wed, Apr 10, 2013 at 02:25:27PM +0200, Ingo Molnar wrote:
>> In my builds I disable that. So I'd suggest to disable that bit in the
>> .config and retry.
> 
> Yep, did that and was able to reproduce the issue in qemu. At a first
> glance, it looks like we're calling kmalloc too early but I need to
> verify this is actually the case. Stay tuned.
> 

OK, this thread took off in another direction but you're still looking
at this, right?

	-hpa


