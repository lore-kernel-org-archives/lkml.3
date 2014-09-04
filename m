Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaIDUvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:51:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43890 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbaIDUvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:51:24 -0400
Message-ID: <5408D0A6.9040505@oracle.com>
Date: Thu, 04 Sep 2014 16:50:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: oleg@redhat.com, riel@redhat.com, kirill.shutemov@linux.intel.com,
        luto@amacapital.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mmap: use pr_emerg when printing BUG related information
References: <1409855782-15089-1-git-send-email-sasha.levin@oracle.com> <20140904133058.37ca7aa2e46a607eed94df3b@linux-foundation.org>
In-Reply-To: <20140904133058.37ca7aa2e46a607eed94df3b@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 04:30 PM, Andrew Morton wrote:
> On Thu,  4 Sep 2014 14:36:22 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Make sure we actually see the output of validate_mm() and browse_rb()
>> before triggering a BUG(). pr_info isn't shown by default so the reason
>> for the BUG() isn't obvious.
>>
> 
> yup, I'll scoot that into 3.17.
> 
> 
> That code's actually pretty cruddy.  How does this look?

The patch looks good.

I've got sidetracked and started working on dump_mm()...


Thanks,
Sasha


