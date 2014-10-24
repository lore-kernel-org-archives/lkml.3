Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbaJXQdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:33:07 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:34555 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaJXQdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:33:03 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: PINTU KUMAR <pintu.k@samsung.com>, akpm@linux-foundation.org,
        riel@redhat.com, aquini@redhat.com, paul.gortmaker@windriver.com,
        jmarchan@redhat.com, lcapitulino@redhat.com,
        kirill.shutemov@linux.intel.com, m.szyprowski@samsung.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        lauraa@codeaurora.org, gioh.kim@lge.com, mgorman@suse.de,
        rientjes@google.com, hannes@cmpxchg.org, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: pintu_agarwal@yahoo.com, cpgs@samsung.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
In-Reply-To: <019601cfef75$8fbf8860$af3e9920$@samsung.com>
Organization: http://mina86.com/
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com> <1413986796-19732-1-git-send-email-pintu.k@samsung.com> <xa1tegtylnzl.fsf@mina86.com> <019601cfef75$8fbf8860$af3e9920$@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141024:akpm@linux-foundation.org::kge7ArSMimdOz4PR:0000000000000000000000000000000000000T80
X-Hashcash: 1:20:141024:hannes@cmpxchg.org::n7l4rJ3HmN5jUIPY:00000000000000000000000000000000000000000000jnv
X-Hashcash: 1:20:141024:lcapitulino@redhat.com::LOZyEOC8r4r7yoH1:0000000000000000000000000000000000000000U4G
X-Hashcash: 1:20:141024:aquini@redhat.com::eQqcQWRHtJS17I6l:000000000000000000000000000000000000000000000jZZ
X-Hashcash: 1:20:141024:ed.savinay@samsung.com::vptVkfne5ZCgtz8m:0000000000000000000000000000000000000000mVr
X-Hashcash: 1:20:141024:gioh.kim@lge.com::oTJutoIkXbAsGlh3:011Dg
X-Hashcash: 1:20:141024:aneesh.kumar@linux.vnet.ibm.com::k1hhc9bcglzRvv4Q:0000000000000000000000000000001CJv
X-Hashcash: 1:20:141024:iamjoonsoo.kim@lge.com::fme9uKTY6qUG9F5k:0000000000000000000000000000000000000001MO0
X-Hashcash: 1:20:141024:riel@redhat.com::2yLlcJzzTvlAmA19:001kR9
X-Hashcash: 1:20:141024:sasha.levin@oracle.com::g+ThknvkgwseG9yx:00000000000000000000000000000000000000022pA
X-Hashcash: 1:20:141024:mgorman@suse.de::vSf8/bnjosYVyvAs:001toI
X-Hashcash: 1:20:141024:paul.gortmaker@windriver.com::zgzUnjz5FtEqQpVV:0000000000000000000000000000000002Smb
X-Hashcash: 1:20:141024:pintu.k@samsung.com::WaM0wlXeET3QCsDU:0000000000000000000000000000000000000000002s3v
X-Hashcash: 1:20:141024:lauraa@codeaurora.org::la+NkUCRW3zZPqJZ:00000000000000000000000000000000000000003HEM
X-Hashcash: 1:20:141024:rohit.kr@samsung.com::AgK84ELzZJu7YrCh:000000000000000000000000000000000000000003Ild
X-Hashcash: 1:20:141024:vishnu.ps@samsung.com::53Vv7ldRqyY1Hcmb:00000000000000000000000000000000000000003Q9O
X-Hashcash: 1:20:141024:cpgs@samsung.com::ExblaOfg+2OMg/1I:04E6R
X-Hashcash: 1:20:141024:pintu_agarwal@yahoo.com::H10sGPKGR2J7Qfzz:0000000000000000000000000000000000000042fZ
X-Hashcash: 1:20:141024:linux-mm@kvack.org::h8bnOR0HZPszKCH3:00000000000000000000000000000000000000000004kBY
X-Hashcash: 1:20:141024:kirill.shutemov@linux.intel.com::MCB6KQ4KNSgEhNbx:0000000000000000000000000000005MNs
X-Hashcash: 1:20:141024:jmarchan@redhat.com::7sx+R7MTaG2ZVSr8:0000000000000000000000000000000000000000006n3U
X-Hashcash: 1:20:141024:linux-kernel@vger.kernel.org::Tz7I5s2JkWnFK5pT:0000000000000000000000000000000007HCy
X-Hashcash: 1:20:141024:m.szyprowski@samsung.com::aT72wIWs7U3+IX0s:0000000000000000000000000000000000000A30e
X-Hashcash: 1:20:141024:rientjes@google.com::HGpzl9W5UHkcBkYQ:000000000000000000000000000000000000000000B9Gs
X-Hashcash: 1:20:141024:vbabka@suse.cz::emJZXEbd2Glf1aes:000HHxp
Date: Fri, 24 Oct 2014 18:32:57 +0200
Message-ID: <xa1tioj92zt2.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Wed, Oct 22 2014, Pintu Kumar wrote:
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index dd73f9a..ababbd8 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_count_lock);
>>>   
>>>   unsigned long totalram_pages __read_mostly;
>>>   unsigned long totalreserve_pages __read_mostly;
>>> +unsigned long totalcma_pages __read_mostly;
>> 
>> Move this to cma.c.

On Fri, Oct 24 2014, PINTU KUMAR <pintu.k@samsung.com> wrote:
> In our earlier patch (first version), we added it in cmc.c itself.
> But, Andrew wanted this variable to be visible in non-CMA case as well to avoid build error, when we use 
> this variable in mem_init_print_info, without CONFIG_CMA.
> So, we moved it to page_alloc.c

If you add 

+#ifdef CONFIG_CMA
+extern unsigned long totalcma_pages;
+#else
+#  define totalcma_pages 0UL
+#endif

to linux/cma.h the variable will get replaced with a constant zero if
!CONFIG_CMA.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
