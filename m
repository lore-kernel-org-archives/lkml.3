Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3KHLES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 06:04:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab3KHLEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 06:04:16 -0500
Message-ID: <527CC50D.4060905@redhat.com>
Date: Fri, 08 Nov 2013 06:03:41 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>, Mark Tinguely <tinguely@sgi.com>,
        Ben Myers <bpm@sgi.com>
CC: elder@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        xfs@oss.sgi.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: XFS leadership and a new co-maintainer candidate
References: <20131107220208.GY1935@sgi.com> <527C0F64.3010906@sgi.com> <527C4B27.6020205@redhat.com>
In-Reply-To: <527C4B27.6020205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the XFS community, we have 2 clear leaders in terms of contributions of 
significant feaures and depth of knowledge - Christoph and Dave.

If you look at the number of patches submitted by developers since 3.0 who have 
more than 10 patches, we get the following:

     319 Author: Dave Chinner <dchinner@redhat.com>
     163 Author: Christoph Hellwig <hch@infradead.org>
      51 Author: Christoph Hellwig <hch@lst.de>
      35 Author: Linus Torvalds <torvalds@linux-foundation.org>
      34 Author: Chandra Seetharaman <sekharan@us.ibm.com>
      29 Author: Al Viro <viro@zeniv.linux.org.uk>
      28 Author: Brian Foster <bfoster@redhat.com>
      25 Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
      24 Author: Jeff Liu <jeff.liu@oracle.com>
      21 Author: Jie Liu <jeff.liu@oracle.com>
      20 Author: Mark Tinguely <tinguely@sgi.com>
      16 Author: Dave Chinner <david@fromorbit.com>
      12 Author: Eric Sandeen <sandeen@redhat.com>
      12 Author: Carlos Maiolino <cmaiolino@redhat.com>

If we as a community had more capacity for patch review, Dave's numbers would 
have jumped up even higher :)

It is certainly very welcome to bring new developers into our community, but if 
we are going to add a co-maintainer for XFS, we really need to have one of our 
two leading developers in that role.

Best regards,

Ric



On 11/07/2013 09:23 PM, Ric Wheeler wrote:
> Hi Ben,
>
> How exactly did we decide to add a new co-maintainer? Shouldn't we have some 
> discussion on the list and see some substantial history of contributions?
>
> Best regards,
>
> Ric
>
>
> On 11/07/2013 05:08 PM, Mark Tinguely wrote:
>> Updated maintainer info.
>>
>> Signed-off-by: Ben Myers <bpm@sgi.com>
>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/MAINTAINERS
>> ===================================================================
>> --- a/MAINTAINERS    2013-11-07 15:42:04.554561805 -0600
>> +++ b/MAINTAINERS    2013-11-07 15:42:59.034889770 -0600
>> @@ -9388,7 +9388,7 @@ F:    drivers/xen/*swiotlb*
>>  XFS FILESYSTEM
>>  P:    Silicon Graphics Inc
>>  M:    Ben Myers <bpm@sgi.com>
>> -M:    Alex Elder <elder@kernel.org>
>> +M:    Mark Tinguely <tinguely@sgi.com>
>>  M:    xfs@oss.sgi.com
>>  L:    xfs@oss.sgi.com
>>  W:    http://oss.sgi.com/projects/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

