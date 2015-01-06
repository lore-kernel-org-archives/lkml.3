Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbbAFKId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:08:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53683 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbbAFKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:08:31 -0500
X-AuditID: cbfee68f-f791c6d000004834-24-54abb41dfd58
From: Jingoo Han <jg1.han@samsung.com>
To: "'Christoph Jaeger'" <cj@linux.com>
Cc: "'Petr Mladek'" <pmladek@suse.cz>, jpoimboe@redhat.com,
        sjenning@redhat.com, jkosina@suse.cz, vojtech@suse.cz,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1420515249-4848-1-git-send-email-cj@linux.com>
 <20150106081536.GA18193@pathway.suse.cz>
In-reply-to: <20150106081536.GA18193@pathway.suse.cz>
Subject: Re: [PATCH linux-next] livepatch: kconfig: use bool instead of boolean
Date: Tue, 06 Jan 2015 19:09:07 +0900
Message-id: <002701d02998$cf00ac40$6d0204c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdApiPliQ6KoeAcSS7aY0aKBetHPyQAD1mRw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkXVd2y+oQgw/dqhbrXzYzWlxeeInV
	YvecxSwWB36eAHJ3zWGzOHPwHpvFwv+bmSx2XXzCZjHpfweLA6fHkyvTmTze77vK5tG3ZRWj
	x5kFR9g9Pm+SC2CN4rJJSc3JLEst0rdL4Mo4tmw2e8FirorGp+4NjLM5uhg5OSQETCQW7d7E
	DGGLSVy4t56ti5GLQ0hgKaPEyp5l7DBF/asXsEAkpjNKnF54mB3C+cUosWf5NUaQKjYBNYkv
	Xw6DdYgIqEo8PbmWBcRmFrgC1DFFEMQWEkiT6D5xFqyGU8BUounffSYQW1jAX+LMl+1gZ7AA
	9XbPeQ7Uy8HBK2ArcXChEkiYV0BQ4sfke1AjtSTW7zzOBGHLS2xe85YZpFxCQF3i0V9diAuM
	JHZu3MsKUSIise/FO0aIX76ySzTeSoTYJCDxbfIhFohWWYlNB6DhIClxcMUNlgmMErOQLJ6F
	ZPEsJItnIdmwgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZgNJ/+96x/B+PdA9aHGAU4
	GJV4eD26VocIsSaWFVfmHmI0BbpoIrOUaHI+MGXklcQbGpsZWZiamBobmVuaKYnzLpT6GSwk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsWrhZm7dsBRuzoJ54fuq6v4Vnw8/sVCol7H80aEV
	/aqtNsFTP0rd1NpzOOl5qceWPwxlGUeLOc5MMne5xRN0pKTh2nwtD+9Qx2DOpRdTgwIO388/
	n/VIvnaen1uLb/mjlasKfEInX284vMivwGtjTUP37OeGa0Q1VrxI126dPzHrxtObZ2ecV2Ip
	zkg01GIuKk4EADthQ/HhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQV3ZLatDDN6tVLBY/7KZ0eLywkus
	FrvnLGaxOPDzBJC7aw6bxZmD99gsFv7fzGSx6+ITNotJ/ztYHDg9nlyZzuTxft9VNo++LasY
	Pc4sOMLu8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QRUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGPLZrMX
	LOaqaHzq3sA4m6OLkZNDQsBEon/1AhYIW0ziwr31bF2MXBxCAtMZJU4vPMwO4fxilNiz/Boj
	SBWbgJrEly8gCU4OEQFViacn14J1MwtcAeqYIghiCwmkSXSfOAtWwylgKtH07z4TiC0s4C9x
	5st2ZhCbBai3e85zoF4ODl4BW4mDC5VAwrwCghI/Jt+DGqklsX7ncSYIW15i85q3zCDlEgLq
	Eo/+6kJcYCSxc+NeVogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6
	xYm5xaV56XrJ+bmbGMHJ4pn0DsZVDRaHGAU4GJV4eD27VocIsSaWFVfmHmKU4GBWEuHdMR0o
	xJuSWFmVWpQfX1Sak1p8iNEU6M+JzFKiyfnARJZXEm9obGJmZGlkZmFkYm6uJM6rZN8WIiSQ
	nliSmp2aWpBaBNPHxMEp1cA44+LRD3M4Fhz0P7x9trjAxmMibzc8Ovnbv2Rz01bn6H4FDlOj
	a/dWdxaw3DKLym843Zu4Wzlk6tzVa0tiGzLnvHS9m1nNbuujFMgf+sS36cujDe/6dp+5zNtk
	rKi1/EydUcOVdbZP9wWulHlxUrVPv7WSgUuuqlfiw/r1Oz/mWq+bV/KZSfKbEktxRqKhFnNR
	cSIAGxm+siwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 06, 2015 5:16 PM, Petr Mladek wrote:
> 
> On Mon 2015-01-05 22:34:09, Christoph Jaeger wrote:
> > Keyword 'boolean' for type definition attributes is considered deprecated and
> > should not be used anymore. No functional changes.
> >
> > Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> > Reference: http://lkml.kernel.org/r/1419108071-11607-1-git-send-email-cj@linux.com
> > Signed-off-by: Christoph Jaeger <cj@linux.com>
> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
> Thanks for the patch.
> 
> Best Regards,
> Petr
> 
> > ---
> >  kernel/livepatch/Kconfig | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
> > index 96da00f..66797aa 100644
> > --- a/kernel/livepatch/Kconfig
> > +++ b/kernel/livepatch/Kconfig
> > @@ -1,10 +1,10 @@
> >  config ARCH_HAVE_LIVE_PATCHING
> > -	boolean
> > +	bool
> >  	help
> >  	  Arch supports kernel live patching
> >
> >  config LIVE_PATCHING
> > -	boolean "Kernel Live Patching"
> > +	bool "Kernel Live Patching"
> >  	depends on DYNAMIC_FTRACE_WITH_REGS
> >  	depends on MODULES
> >  	depends on SYSFS
> > --
> > 2.1.0

