Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab3HNHcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:32:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40828 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397Ab3HNHcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:32:31 -0400
Message-ID: <520B3240.6030208@zytor.com>
Date: Wed, 14 Aug 2013 00:31:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] mm: Unify pte_to_pgoff and pgoff_to_pte helpers
References: <20130814070059.GJ2869@moon> <520B303D.2090206@zytor.com> <20130814072453.GK2869@moon>
In-Reply-To: <20130814072453.GK2869@moon>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 12:24 AM, Cyrill Gorcunov wrote:
> On Wed, Aug 14, 2013 at 12:22:37AM -0700, H. Peter Anvin wrote:
>> On 08/14/2013 12:00 AM, Cyrill Gorcunov wrote:
>>> +#define pte_bfop(v,r,m,l)	((((v) >> (r)) & (m)) << (l))
>>
>> "bfop"?
> 
> B_it_F_ield_OP_eration, Peter I don't mind to use any other
> name, this was just short enough to type.
> 

I think it would be useful to have a comment what it means and what
v,r,m,l represent.

Perhaps m should be mask width rather than the actual mask?

	-hpa

