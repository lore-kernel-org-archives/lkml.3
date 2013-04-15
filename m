Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3DOKJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:09:05 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:39755 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3DOKJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:09:03 -0400
Date: Mon, 15 Apr 2013 12:08:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130415100858.GB18024@gmail.com>
References: <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
 <51670E51.6020106@zytor.com>
 <20130411202328.GA15955@pd.tnic>
 <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412112628.GB2368@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> And 0x00003f76 + 0x104 gives exactly 0x0000407a which is the address at
> which we #PF:
> 
> [   15.921486] BUG: unable to handle kernel paging request at 0000407a
> [   15.921486] IP: [<41071ab0>] __lock_acquire.isra.19+0x3e0/0xb00
> 
> More hmmm...

It gave me the impression of memory corruption - but impressions can deceive ;-)

Anyway, not sure I can test/bisect it this week - merge window preparations and 
all that.

Thanks,

	Ingo
