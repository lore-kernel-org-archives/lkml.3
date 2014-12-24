Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaLXH4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:56:50 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:14633 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLXH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:56:48 -0500
Message-ID: <549A71AC.9030002@huawei.com>
Date: Wed, 24 Dec 2014 15:56:28 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Ben Hutchings <ben@decadent.org.uk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 3.2 042/164] vfs: fix data corruption when blocksize <
 pagesize for mmaped data
References: <lsq.1418364865.554543691@decadent.org.uk> <lsq.1418364865.368665223@decadent.org.uk> <20141212084815.GA4813@quack.suse.cz>
In-Reply-To: <20141212084815.GA4813@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.549A71B4.00F3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9be54fd3be07cbba43026444f55871ed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/12 16:48, Jan Kara wrote:
> On Fri 12-12-14 06:14:25, Ben Hutchings wrote:
>> 3.2.65-rc1 review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Jan Kara <jack@suse.cz>
>>
>> commit 90a8020278c1598fafd071736a0846b38510309c upstream.
>   This patch needs also commit f55fefd1a5a339b1bd08c120b93312d6eb64a9fb,
> otherwise XFS will spew lots of false warnings...
> 

I've also applied this to 3.4. Thanks!

