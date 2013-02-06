Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab3BFV4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:56:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37128 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046Ab3BFV4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:56:44 -0500
Message-ID: <5112D13C.7030406@zytor.com>
Date: Wed, 06 Feb 2013 13:55:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
References: <1356564746.7010.56.camel@shinybook.infradead.org> <50DB9FA5.6070704@infradead.org> <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com> <20130204184436.GA13256@gmail.com> <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com> <20130204191408.GA32081@kroah.com> <20130204191334.GB14837@gmail.com> <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com> <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com> <20130207080236.ae38366537cf3f13b9668606@canb.auug.org.au> <20130206214646.GA28135@gmail.com>
In-Reply-To: <20130206214646.GA28135@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 01:46 PM, Ingo Molnar wrote:
>>
>> Linus has said that he will not take the kvmtool tree in its 
>> current form, but would prefer that it be a separate project, 
>> so I should really drop it from linux-next (and ask the tip 
>> guys to remove it from their auto-latest branch).
>>
>> I have actually been meaning to get back to this, so, today I 
>> will drop the kvmtool tree and, Ingo, if you could (at your 
>> convenience i.e. when you are next rebasing it) remove it from 
>> tip/auto-latest, thanks.
> 
> Pekka still intends to send it in the next merge window AFAIK, 
> and I use it for testing rather frequently so I'm not going to 
> remove it from my tree for the time being.
> 
> Note that I never actually had any maintenance problems due to 
> it: it's orthogonal, and as long as you don't use it explicitly 
> (such as its 'make kvmconfig' feature - which is rather handy) 
> it never actually broke anything.
> 

So why don't we let Linus either accept and reject it for the 3.9 merge,
but it rejected, we drop it from linux-next until such time as Linus'
objections have been addressed?

	-hpa


