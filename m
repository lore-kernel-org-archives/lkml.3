Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3BXBkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 20:40:07 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50078 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab3BXBkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 20:40:05 -0500
Message-ID: <51296F49.40103@gmail.com>
Date: Sun, 24 Feb 2013 09:39:21 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] ksm: responses to NUMA review
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils> <5126E987.7020809@gmail.com> <alpine.LNX.2.00.1302221227530.6100@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1302221227530.6100@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2013 04:38 AM, Hugh Dickins wrote:
> On Fri, 22 Feb 2013, Ric Mason wrote:
>> On 02/21/2013 04:17 PM, Hugh Dickins wrote:
>>> Here's a second KSM series, based on mmotm 2013-02-19-17-20: partly in
>>> response to Mel's review feedback, partly fixes to issues that I found
>>> myself in doing more review and testing.  None of the issues fixed are
>>> truly show-stoppers, though I would prefer them fixed sooner than later.
>> Do you have any ideas ksm support page cache and tmpfs?
> No.  It's only been asked as a hypothetical question: I don't know of
> anyone actually needing it, and I wouldn't have time to do it myself.
>
> It would be significantly more invasive than just dealing with anonymous
> memory: with anon, we already have the infrastructure for read-only pages,
> but we don't at present have any notion of read-only pagecache.
>
> Just doing it in tmpfs?  Well, yes, that might be easier: since v3.1's
> radix_tree rework, shmem/tmpfs mostly goes through its own interfaces
> to pagecache, so read-only pagecache, and hence KSM, might be easier
> to implement there than more generally.

Ok, are there potential users to take advantage of it?

>
> Hugh

