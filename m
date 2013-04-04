Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048Ab3DDOi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:38:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23098 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761861Ab3DDOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:38:56 -0400
Message-ID: <515D9041.8080000@oracle.com>
Date: Thu, 04 Apr 2013 10:37:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
References: <51559150.3040407@oracle.com> <515D882E.6040001@oracle.com> <20130404143048.02672E0085@blue.fi.intel.com>
In-Reply-To: <20130404143048.02672E0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 10:30 AM, Kirill A. Shutemov wrote:
> Sasha Levin wrote:
>> Ping? I'm seeing a whole bunch of these with current -next.
> 
> Do you have a way to reproduce?

Not really, trinity just manages to make it happen quite often.

I can add something in the code to spew more debug info when it
happens though, I just couldn't come up with anything that might
be useful.


Thanks,
Sasha
