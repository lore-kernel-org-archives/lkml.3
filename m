Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaD2I20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:28:26 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38189 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbaD2I2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:28:22 -0400
Message-ID: <535F610F.6090705@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 13:51:35 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davidlohr@hp.com, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
References: <535EA976.1080402@linux.vnet.ibm.com> <20140429000031.GA4284@redhat.com>
In-Reply-To: <20140429000031.GA4284@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042908-3568-0000-0000-000005666B96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 05:30 AM, Dave Jones wrote:
> On Tue, Apr 29, 2014 at 12:48:14AM +0530, Srivatsa S. Bhat wrote:
>  > Hi,
>  > 
>  > I hit this during boot on v3.15-rc3, just once so far.
>  > Subsequent reboots went fine, and a few quick runs of multi-
>  > threaded ebizzy also didn't recreate the problem.
>  > 
>  > The kernel I was running was v3.15-rc3 + some totally
>  > unrelated cpufreq patches.
> 
> Could you post those patches somewhere ?
> They may not be directly related to the code in the trace, but if
> they are randomly corrupting memory, maybe that would explain things ?
>

Why post them just 'somewhere'? I posted them on LKML! :-)

This is the patchset I was testing:  :-)

https://lkml.org/lkml/2014/4/28/473

Regards,
Srivatsa S. Bhat


