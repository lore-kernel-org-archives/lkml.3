Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab3BSIIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:08:44 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:33583 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460Ab3BSIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:08:41 -0500
Date: Tue, 19 Feb 2013 09:08:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130219080835.GA5241@gmail.com>
References: <20130204184436.GA13256@gmail.com>
 <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
 <20130204191408.GA32081@kroah.com>
 <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
 <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
 <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au>
 <20130206214646.GA28135@gmail.com>
 <20130208084029.d7d97d6e26580a5512712f91@canb.auug.org.au>
 <20130208145539.GC30334@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208145539.GC30334@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> I'll remove it if Linus insists on it, but I think you guys 
> are putting form before substance and utility :-(

So, just to bring this to a conclusion, obviously Linus is 
insisting on it, so I've removed tools/kvm from tip:auto-latest, 
by going back from the daily merges (where tip:master was == 
tip:next) to the older complete reintegration merges to 
linux-next every couple of weeks.

This way tools/kvm will still be available in tip:master (merged 
after full integrations) and there are still the usual daily (or 
more frequent) delta-merges of tip:master as new bits get ready 
- with the occasional riskier total reintegration done for 
linux-next.

It's obviously not optimal, but that's the best I could come up 
with given the constraints.

Thanks,

	Ingo
