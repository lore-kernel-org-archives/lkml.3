Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaFLIzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:55:41 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58500 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbaFLIzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:55:36 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 01/10] DMA, CMA: clean-up log message
In-Reply-To: <20140612055358.GA30128@js1304-P5Q-DELUXE>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com> <87y4x2pwnk.fsf@linux.vnet.ibm.com> <20140612055358.GA30128@js1304-P5Q-DELUXE>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::sTauA4Xi+ZmzCaoo:000000000000000000000000000000000000004Wp
X-Hashcash: 1:20:140612:minchan@kernel.org::pV5O+z+zDBg6MR14:00000000000000000000000000000000000000000000MMy
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::895Z+9u0lgGwQ/dq:0000000000000000000000000000000000Xu7
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::tcy3zmSBNoCk36r3:0000000000000000000000000000000Yo2
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::BLjWs3WnDu7BmxYS:0000000000000000000000000000000000000000000qVt
X-Hashcash: 1:20:140612:pbonzini@redhat.com::B47R03mV8FuRRe3p:0000000000000000000000000000000000000000001tNS
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::K3JjsmQl5KGdm6wd:000000000000000000000000000000000000002W0l
X-Hashcash: 1:20:140612:gleb@kernel.org::vUZasQYQA9abhdc2:003ZVX
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::O2TIqE4m77ylxjve:000000000000000000000000000000000000044U4
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::3FpbKDSwYG3q/bxg:0000000000000000000000000000000000004xRo
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::xEGPCWusyJc9KjCW:00000000000000000000000000000000575B
X-Hashcash: 1:20:140612:paulus@samba.org::dxuxA13uqioSjcY5:075ef
X-Hashcash: 1:20:140612:linux-mm@kvack.org::O6hdgkDKR55IFHcb:00000000000000000000000000000000000000000006lei
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::tlJ9M6jFeb9TKTp9:000000000000000000000000000000000006ZC2
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::YJQIwJfW+v4wGoqA:0000000000000000000000000000000000000009Xn8
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::xHktPEdSwiajupmA:000000000000000000000000000000000000000BQYn
X-Hashcash: 1:20:140612:agraf@suse.de::/MK1Dr1CpHtOj5Xy:0000DwMD
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::x82YmKjYAcOlZ/Av:0000000000000000000000000FHRA
Date: Thu, 12 Jun 2014 10:55:32 +0200
Message-ID: <xa1toaxyjym3.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>> 
>> > We don't need explicit 'CMA:' prefix, since we already define prefix
>> > 'cma:' in pr_fmt. So remove it.
>> >
>> > And, some logs print function name and others doesn't. This looks
>> > bad to me, so I unify log format to print function name consistently.
>> >
>> > Lastly, I add one more debug log on cma_activate_area().
>> >
>> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> >
>> > diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
>> > index 83969f8..bd0bb81 100644
>> > --- a/drivers/base/dma-contiguous.c
>> > +++ b/drivers/base/dma-contiguous.c
>> > @@ -144,7 +144,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>> >  	}
>> >
>> >  	if (selected_size && !dma_contiguous_default_area) {
>> > -		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
>> > +		pr_debug("%s(): reserving %ld MiB for global area\n", __func__,
>> >  			 (unsigned long)selected_size / SZ_1M);

> On Thu, Jun 12, 2014 at 10:11:19AM +0530, Aneesh Kumar K.V wrote:
>> Do we need to do function(), or just function:. I have seen the later
>> usage in other parts of the kernel.

On Thu, Jun 12 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> I also haven't seen this format in other kernel code, but, in cma, they use
> this format as following.
>
> function(arg1, arg2, ...): some message
>
> If we all dislike this format, we can change it after merging this
> patchset. Until then, it seems better to me to leave it as is.

I used “function(arg1, arg2, …)” at the *beginning* of functions when
the arguments passed to the function were included in the message.  In
all other cases I left it at just “function:” (or just no additional
prefix).  IMO that's a reasonable strategy.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
