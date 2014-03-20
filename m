Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaCTOUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:20:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCTOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:20:11 -0400
Message-ID: <532AF8E8.8030101@oracle.com>
Date: Thu, 20 Mar 2014 10:19:20 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
References: <20140311171045.GA4693@redhat.com> <20140311173603.GG32390@moon> <20140311173917.GB4693@redhat.com> <alpine.LSU.2.11.1403181703470.7055@eggly.anvils> <5328F3B4.1080208@oracle.com> <20140319020602.GA29787@redhat.com> <20140319021131.GA30018@redhat.com> <alpine.LSU.2.11.1403181918130.3423@eggly.anvils> <20140319145200.GA4608@redhat.com> <alpine.LSU.2.11.1403192147470.971@eggly.anvils> <20140320135137.GA2263@redhat.com>
In-Reply-To: <20140320135137.GA2263@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 09:51 AM, Dave Jones wrote:
> On Wed, Mar 19, 2014 at 10:00:29PM -0700, Hugh Dickins wrote:
>
>   > > This might be collateral damage from the swapops thing, I guess we won't know until
>   > > that gets fixed, but I thought I'd mention that we might still have a problem here.
>   >
>   > Yes, those Bad rss-counters could well be collateral damage from the
>   > swapops BUG.  To which I believe I now have the answer: again untested,
>   > but please give this a try...
>
> This survived an overnight run. No swapops bug, and no bad RSS. Good job:)

Same here, swapops bug is gone!


Thanks,
Sasha
