Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3HQPou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 11:44:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58359 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab3HQPot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 11:44:49 -0400
Date: Sat, 17 Aug 2013 17:44:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Youquan Song <youquan.song@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130817154447.GB10005@pd.tnic>
References: <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
 <20130724062254.GA16400@redhat.com>
 <CAE9FiQWbVDRpLUCUTF=Jpmm-nn6kgBYFW25PPTEiPK-R-mX0jA@mail.gmail.com>
 <20130729170514.GB30371@linux-youquan.bj.intel.com>
 <20130814184040.GA6726@linux-youquan.bj.intel.com>
 <20130814111105.GA13772@gmail.com>
 <20130817134454.GA16835@linux-youquan.bj.intel.com>
 <20130817074256.GA18772@gmail.com>
 <20130817082419.GA10005@pd.tnic>
 <1376730231.1954.7.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376730231.1954.7.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 02:03:51AM -0700, Joe Perches wrote:
> checkpatch tends to be used for firs patch submissions and
> adding it would only encourage a new wave of trivial whitespace
> patches.

Nope, we definitely don't want that...

> I think there are already way, _way_ too many existing instances
> of comments that are of the form
> 	/* foo
> 	 * ...
> to add that.
> 
> There are 10s of thousands outside of net/ and drivers/net/.

... unless there's a way to detect new submissions and scream only
for those. I.e., look at lines starting with "+" which don't have
corresponding "-" lines.

This would need a bit of experimenting and is not trivial though, maybe
Algorithm::Diff could even help there.

Sounds like a mini-project for a perl dude :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
