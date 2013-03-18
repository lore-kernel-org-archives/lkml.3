Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3CRWxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:53:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40411 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3CRWxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:53:08 -0400
Message-ID: <51479A36.3050600@zytor.com>
Date: Mon, 18 Mar 2013 15:50:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Lin Feng <linfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, penberg@kernel.org,
        jacob.shin@amd.com
Subject: Re: [PATCH] x86: mm: accurate the comments for STEP_SIZE_SHIFT macro
References: <1363602068-11924-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQWuSL5Vq5VaAvQg_NT2gQJr17eMNoQbxtNJ8G3wweWNHQ@mail.gmail.com> <51476402.7050102@zytor.com> <CAE9FiQUZDqqeAp2y=Pc9yFT81Pf+ei2SEx4NUD6jC+nQmd6PcA@mail.gmail.com> <514767A5.4020601@zytor.com> <CAE9FiQU2iqx=9LEx_u6J5O_kQ-5Lo6DTgSgnk71k0p6WWUa7Hg@mail.gmail.com>
In-Reply-To: <CAE9FiQU2iqx=9LEx_u6J5O_kQ-5Lo6DTgSgnk71k0p6WWUa7Hg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 02:19 PM, Yinghai Lu wrote:
> On Mon, Mar 18, 2013 at 12:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Instead, try to explain why 5 is the correct value in the current code
>> and how it is (or should be!) derived.
> 
> initial mapped size is PMD_SIZE, aka 2M.
> if we use step_size to be PUD_SIZE aka 1G, as most worse case
> that 1G is cross the 1G boundary, and PG_LEVEL_2M is not set,
> we will need 1+1+512 pages (aka 2M + 8k) to map 1G range with PTE.
> So i picked (30-21)/2 to get 5.
> 
> Please check attached patch.
> 
> Thanks
> 
> Yinghai
> 

This still seems very opaque.  I need to look at it and see if it makes
more sense in context.

	-hpa

