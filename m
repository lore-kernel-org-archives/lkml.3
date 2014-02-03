Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaBCSRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:17:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9889 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbaBCSRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:17:15 -0500
Message-ID: <52EFDD80.4050800@fb.com>
Date: Mon, 3 Feb 2014 13:18:40 -0500
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <dsterba@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
References: <52EAC9B6.7090603@fb.com> <20140203175405.GL1364@twin.jikos.cz>
In-Reply-To: <20140203175405.GL1364@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-03_02:2014-01-31,2014-02-03,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03 Feb 2014 12:54:05 PM EST, David Sterba wrote:
> On Thu, Jan 30, 2014 at 04:52:54PM -0500, Chris Mason wrote:
>> Chris Mason (3) commits (+64/-32):
>>      Btrfs: setup inode location during btrfs_init_inode_locked (+9/-9)
>>      Btrfs: don't use ram_bytes for uncompressed inline items (+52/-22)
>
> The patches are CC: stable, but haven't gone through the mailinglist.
> Are they still going to be picked by stable?

We do need both in -stable, I'll help with backports.

-chris

