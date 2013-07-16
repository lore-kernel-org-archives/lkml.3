Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3GPB1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:27:44 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38805 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab3GPB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:27:38 -0400
Message-ID: <51E4A181.2030707@gmail.com>
Date: Tue, 16 Jul 2013 09:27:29 +0800
From: Sam Ben <sam.bennn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] mm, hugetlb: clean-up and possible bug fix
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <871u6zkj7b.fsf@linux.vnet.ibm.com> <20130716011054.GC2430@lge.com>
In-Reply-To: <20130716011054.GC2430@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 09:10 AM, Joonsoo Kim wrote:
> On Mon, Jul 15, 2013 at 07:40:16PM +0530, Aneesh Kumar K.V wrote:
>> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>>
>>> First 5 patches are almost trivial clean-up patches.
>>>
>>> The others are for fixing three bugs.
>>> Perhaps, these problems are minor, because this codes are used
>>> for a long time, and there is no bug reporting for these problems.
>>>
>>> These patches are based on v3.10.0 and
>>> passed sanity check of libhugetlbfs.
>> does that mean you had run with libhugetlbfs test suite ?
> Yes! I can't find any reggression on libhugetlbfs test suite.

Where can get your test case?

>
>>   
>> -aneesh
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

