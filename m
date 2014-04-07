Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbaDGO5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:57:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20220 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaDGO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:57:06 -0400
Message-ID: <5342BCB1.9010109@oracle.com>
Date: Mon, 07 Apr 2014 10:56:49 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
References: <51559150.3040407@oracle.com> <515D882E.6040001@oracle.com> <533F09F0.1050206@oracle.com> <20140407144835.GA17774@node.dhcp.inet.fi>
In-Reply-To: <20140407144835.GA17774@node.dhcp.inet.fi>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 10:48 AM, Kirill A. Shutemov wrote:
> On Fri, Apr 04, 2014 at 03:37:20PM -0400, Sasha Levin wrote:
>> > And another ping exactly a year later :)
> I think we could "fix" this false positive with the patch below
> (untested), but it's ugly and doesn't add much value.

I could carry that patch myself and not complain about it
any more if there's no intent to produce a "real" fix, but
I doubt that that's really the path we want to take in the
long run.

We'll end up with a bunch of broken paths when enabling
debug, making any sort of debugging slow and useless, which
isn't a desirable result to say the least.


Thanks,
Sasha
