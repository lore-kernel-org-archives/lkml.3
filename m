Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaHIJRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 05:17:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaHIJRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 05:17:13 -0400
Message-ID: <53E5E714.6030703@nod.at>
Date: Sat, 09 Aug 2014 11:17:08 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] Global signal cleanup
References: <53E20F1E.2080606@nod.at> <53E3E53B.8060705@synopsys.com>
In-Reply-To: <53E3E53B.8060705@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet,

Am 07.08.2014 22:44, schrieb Vineet Gupta:
> Hi Richard,
> 
> On Wednesday 06 August 2014 04:18 AM, Richard Weinberger wrote:
>>       arc: Use get_signal() signal_setup_done()
> 
> I'd added this patch into arc tree for 3.17 (in linux-next for a while) and AFAIKR
> I'd also left you a note to same effect. However it seems you are routing
> everything thru ur tree, so I'll drop it from mine - OK ?

Yes, please drop it from your tree.
Technically git merge will not cry about the double commit but
let's keep the history clean.

Thanks,
//richard
