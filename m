Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbaGPAA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:00:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761029AbaGPAAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:00:22 -0400
Message-ID: <53C5C066.2060707@zytor.com>
Date: Tue, 15 Jul 2014 16:59:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 3/11] x86, mm, pat: Change reserve_memtype() to handle
 WT type
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com> <1405452884-25688-4-git-send-email-toshi.kani@hp.com> <CALCETrUPpP1Lo1gB_eTm6V3pJ3Fam-1gPZGKfksOXXGgtNGsEQ@mail.gmail.com> <1405465801.28702.34.camel@misato.fc.hp.com> <CALCETrUx+HkzBmTZo-BtOcOz7rs=oNcavJ9Go536Fcn2ugdobg@mail.gmail.com> <53C5BD3E.2010600@zytor.com> <CALCETrUV2NseM8u6YqQ3trqLy+10_A6sd7nmfkgO3Rnw3GSxiQ@mail.gmail.com>
In-Reply-To: <CALCETrUV2NseM8u6YqQ3trqLy+10_A6sd7nmfkgO3Rnw3GSxiQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 04:54 PM, Andy Lutomirski wrote:
> 
> From vague memory, the current mechanism for tracking RAM memtypes (as
> opposed to memtypes for everything that isn't RAM) is limited to a
> very small number of types, leading to oddities like not being able to
> create WT ram with this patchset.
> 
> Using the pagetables directly would be simpler (no extra data
> structure) and would automatically exactly track the set of memtypes
> that can fit in the pagetable structures.
> 

I don't think there is anything fundamental, though.  The number of
types had more to do with what there was demand for.  I will look into it.

	-hpa


