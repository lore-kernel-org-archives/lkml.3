Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbaLLKcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:32:01 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:64302 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758149AbaLLKb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:31:59 -0500
Message-ID: <1418380316.5756.37.camel@x220>
Subject: Re: linux-next: Tree for Dec 12
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 12 Dec 2014 11:31:56 +0100
In-Reply-To: <20141212210449.7f460bb1@canb.auug.org.au>
References: <20141212183518.06e3803d@canb.auug.org.au>
	 <1418377757.5756.24.camel@x220> <20141212210449.7f460bb1@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2014 10:31:56.0940 (UTC) FILETIME=[DAB864C0:01D015F6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 21:04 +1100, Stephen Rothwell wrote:
> That patch has been in linux-next since Dec 3 as commit 77a4494388ab in
> Andrew's patch set (and maybe earlier).

Not earlier. Commit 77a4494388ab debuted in next-20141203:
        $ git tag --contains 77a4494388ab
        next-20141203
        next-20141204
        next-20141205
        next-20141208
        next-20141209
        next-20141210
        next-20141211
        next-20141212
        
I missed that commit. But then again it never occurred to me that a
Kconfig symbol would be added and removed in one series. And, obviously,
grepping for INIT_FALLBACK didn't show anything in linux-next before
today (the oldest tree I checked was next-20141201, after which I lost
interest in going back any further). 

>   However, also in Adnrew's
> patch set is another patch ("init: remove CONFIG_INIT_FALLBACK") that
> then removes CONFIG_INIT_FALLBACK.  There is a conflict because the
> first has gone into Linus' tree today (as commit 6ef4536e2f19), but the
> second has not (I don't know why not).
> 
> Hmmm, I would have expected the Kconfig entry to be removed as well,
> but either I missed that, or git is not as clever as I expect it to be.
> 
> > Anyhow, I'm sure this all will be sorted out in due time.
> 
> I hope so.

I won't be bothering (Andrew and) you again about this. Unless sorting
this out takes rather long, that is.

Thanks,


Paul Bolle

