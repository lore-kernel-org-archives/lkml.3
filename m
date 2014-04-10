Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713AbaDJOlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:41:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48126 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965659AbaDJOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:41:37 -0400
Message-ID: <5346AD92.2080705@oracle.com>
Date: Thu, 10 Apr 2014 10:41:22 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Bob Liu <lliubbo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:1829!
References: <53440991.9090001@oracle.com> <CAA_GA1d_boVA67EBK5Rv7_F_8pb_5rBA10WB9ooCdjON93C03w@mail.gmail.com> <20140410143734.GA939@redhat.com>
In-Reply-To: <20140410143734.GA939@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 10:37 AM, Dave Jones wrote:
> On Thu, Apr 10, 2014 at 04:45:58PM +0800, Bob Liu wrote:
>  > On Tue, Apr 8, 2014 at 10:37 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>  > > Hi all,
>  > >
>  > > While fuzzing with trinity inside a KVM tools guest running the latest -next
>  > > kernel, I've stumbled on the following:
>  > >
>  > 
>  > Wow! There are so many huge memory related bugs recently.
>  > AFAIR, there were still several without fix. I wanna is there any
>  > place can track those bugs instead of lost in maillist?
>  > It seems this link is out of date
>  > http://codemonkey.org.uk/projects/trinity/bugs-unfixed.php
>  
> It got to be too much for me to track tbh.
> Perhaps this is one of the cases where using bugzilla.kernel.org might
> be a useful thing ?

FWIW, I'd be happy to use something else besides having to track mail
threads and keep a list of "to-do open issues".

If folks want to start using bugzilla.kernel.org for mm/ issues I'll go
ahead and enter all the open issues in there.


Thanks,
Sasha
