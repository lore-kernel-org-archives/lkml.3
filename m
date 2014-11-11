Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaKKHVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:21:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50906 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKKHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:21:52 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-65-5461b90dccd2
Message-id: <5461B906.1040803@samsung.com>
Date: Tue, 11 Nov 2014 10:21:42 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: akpm@linux-foundation.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory
 debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
Content-type: text/plain; charset=koi8-r
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0hTcRzH+Z/LznE0OM3bXyuklWRC5sCHPxEiFHIeDAItohddOtSaF3ZU
	UiQtZeGslMzUOfKyojYG6qy8oKaynGjeNxXzNq9N28oLZZiWTh98+/y+fC8vPxoXThHedHxi
	ilSeKJGJeHyid9c0ckHQJIkINLd6oe3WMhKpa/Q8ZBz9TaGxX98BWmh/DNC6bRag92OPMLRs
	tVKo0Kqg0Ms6T6TNz+Gh8pl5AjUs2TGkzZsl0Uizmoem9f9INNxeiaHctkEMKTZ2SWR62o4h
	+2QJgRSv6zCkMX7FkWOpCEf1hmIcWXQdFBrYMZFoq3aeDDnJVjStAbZJNUWxlYZUtv6dP6tp
	sWGsQZfHYw3rzylWaTdjrKO/n2K7S7cJdsFcgrGaZ0Uku7Y4QbCbulGc/dFm4bFfKo3Uddfb
	/MsxUll8mlR+MTiKH6dY+YYn12L31z4o8GzgAErgQkMmCA402nkH7AEHp2v2mE8LmTcAlm7P
	gYMjB4M267gzIWD84ZORKkwJaJpgfOFMC7cv85gAuKtqcBa5M7egWa8+tB+HW0XTxD67Madg
	8c4Asd+JM70U/DvZ5TS5MuGwW6s+XH4I4MZEnjPhwoRCY0G1k3HGD5orLIfsA+v1drwQMKoj
	I6ojNtURWyXAdcBdmhqdzN2JTRAHcJIELjUxNiA6KcEADl5isxFoui51AoYGomOCwJuSCCEp
	SePSEzoBpHGRmyArak8SxEjSM6TypEh5qkzKdQKMdvHOBtdm5riqjI4l4fCix3jVqLEryGwK
	zQ60LJX3bNaI/0hDzrz6eT5+OSuy2Tezr/pKeIQ9bWj87jypTrnnk2lVdGyQ+cq+2eEymT4z
	eCjm07m3ZZ8z/D7iqzfWTzcwIb7lrrMPcvGwFwUnws56arxWbFovB+oZ14uv5hGrWVm5HSKC
	i5OI/XE5J/kPDTCepvACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Now we have stable GCC(4.9.2) which supports kasan and from my point of view patchset is ready for merging.
I could have sent v7 (it's just rebased v6), but I see no point in doing that and bothering people,
unless you are ready to take it.
So how should I proceed?

Thanks,
Andrey.
