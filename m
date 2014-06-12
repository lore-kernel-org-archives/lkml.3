Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaFLJxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:53:24 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63762 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbaFLJxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:53:21 -0400
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
In-Reply-To: <xa1toaxyjym3.fsf@mina86.com>
Organization: http://mina86.com/
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-2-git-send-email-iamjoonsoo.kim@lge.com> <87y4x2pwnk.fsf@linux.vnet.ibm.com> <20140612055358.GA30128@js1304-P5Q-DELUXE> <xa1toaxyjym3.fsf@mina86.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140612:linux-arm-kernel@lists.infradead.org::2rwBDr/2gHCfL+5B:000000000000000000000000009X1
X-Hashcash: 1:20:140612:kvm-ppc@vger.kernel.org::aRKugmSqUVnVlMRb:000000000000000000000000000000000000000f7p
X-Hashcash: 1:20:140612:minchan@kernel.org::3P+c4ivvBspvvm4U:00000000000000000000000000000000000000000000nQm
X-Hashcash: 1:20:140612:akpm@linux-foundation.org::b5kYLha+GEa/B7Dl:0000000000000000000000000000000000000eNv
X-Hashcash: 1:20:140612:aneesh.kumar@linux.vnet.ibm.com::5+YIL378t78QmNf+:0000000000000000000000000000000hM1
X-Hashcash: 1:20:140612:linux-mm@kvack.org::Tv9WmR0H8Ke9/0/d:00000000000000000000000000000000000000000000rLr
X-Hashcash: 1:20:140612:benh@kernel.crashing.org::AD6Nd8Md9fpwx4Br:00000000000000000000000000000000000001Ia4
X-Hashcash: 1:20:140612:pbonzini@redhat.com::p3uwGxVYFs0c75j2:0000000000000000000000000000000000000000001YyS
X-Hashcash: 1:20:140612:gregkh@linuxfoundation.org::3DPmgqAlaaP9BEhT:0000000000000000000000000000000000020OW
X-Hashcash: 1:20:140612:linux-kernel@vger.kernel.org::cypz0f+uAv4ajZkq:000000000000000000000000000000000261f
X-Hashcash: 1:20:140612:linuxppc-dev@lists.ozlabs.org::UPJNzbEGced+3D2I:000000000000000000000000000000002Exx
X-Hashcash: 1:20:140612:kvm@vger.kernel.org::4OHY3caGQGDNikc7:0000000000000000000000000000000000000000003Wyz
X-Hashcash: 1:20:140612:paulus@samba.org::4JFC8Y7NBzjgXReG:03+ta
X-Hashcash: 1:20:140612:linux@arm.linux.org.uk::XxJILhyglADvsxIp:00000000000000000000000000000000000000040pv
X-Hashcash: 1:20:140612:iamjoonsoo.kim@lge.com::i1q6F1vf8HqiivA1:0000000000000000000000000000000000000007hvz
X-Hashcash: 1:20:140612:agraf@suse.de::mhd6O2UkWS0uBgVL:00009HW2
X-Hashcash: 1:20:140612:m.szyprowski@samsung.com::DswqXKfY133/T4xQ:0000000000000000000000000000000000000DpHy
X-Hashcash: 1:20:140612:gleb@kernel.org::h84xnoNv16uuWxgQ:00SfOG
Date: Thu, 12 Jun 2014 11:53:16 +0200
Message-ID: <xa1tegyujvxv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12 2014, Michal Nazarewicz <mina86@mina86.com> wrote:
> I used “function(arg1, arg2, …)” at the *beginning* of functions when
> the arguments passed to the function were included in the message.  In
> all other cases I left it at just “function:” (or just no additional
> prefix).  IMO that's a reasonable strategy.

At closer inspection, I realised drivers/base/dma-contiguous.c is
Marek's code, but the above I think is still reasonable thing to do, so
I'd rather standardise on having “function(…)” only at the beginning of
a function.  Just my 0.02 CHF.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
