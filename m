Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab3BUJjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:39:24 -0500
Received: from natasha.panasas.com ([67.152.220.90]:45712 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3BUJjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:39:21 -0500
Message-ID: <5125EAB1.9070002@panasas.com>
Date: Thu, 21 Feb 2013 11:36:49 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <axboe@kernel.dk>,
        <lucho@ionkov.net>, <jack@suse.cz>, <ericvh@gmail.com>,
        <viro@zeniv.linux.org.uk>, <rminnich@sandia.gov>, <tytso@mit.edu>,
        <martin.petersen@oracle.com>, Artem Bityutskiy <dedekind1@gmail.com>,
        <neilb@suse.de>, Adrian Hunter <adrian.hunter@intel.com>,
        <david@fromorbit.com>, <gnehzuil.liu@gmail.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <adilger.kernel@dilger.ca>,
        <jlayton@samba.org>, <linux-mtd@lists.infradead.org>,
        <linux-ext4@vger.kernel.org>, <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 6/6] ubifs: Wait for page writeback to provide stable
 pages
References: <20130119011231.20902.55954.stgit@blackbox.djwong.org> <20130119011316.20902.56721.stgit@blackbox.djwong.org> <20130123134312.b69c53cd.akpm@linux-foundation.org> <20130221034834.GA4055@blackbox.djwong.org>
In-Reply-To: <20130221034834.GA4055@blackbox.djwong.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 05:48 AM, Darrick J. Wong wrote:
> On Wed, Jan 23, 2013 at 01:43:12PM -0800, Andrew Morton wrote:
>> On Fri, 18 Jan 2013 17:13:16 -0800
>> "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
>>
>>> When stable pages are required, we have to wait if the page is just
>>> going to disk and we want to modify it. Add proper callback to
>>> ubifs_vm_page_mkwrite().
>>>
>>> CC: Artem Bityutskiy <dedekind1@gmail.com>
>>> CC: Adrian Hunter <adrian.hunter@intel.com>
>>> CC: linux-mtd@lists.infradead.org
>>> From: Jan Kara <jack@suse.cz>
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> A couple of these patches had this From:Jan strangely embedded in the
>> signoff area.  I have assumed that they were indeed authored by Jan.
>>
>> Please note that authorship is indicated by putting the From: line
>> right at the start of the chagnelog.
>>
>>
>> I grabbed the patches.  They should appear in linux-next tomorrow if I
>> can get the current pooppile to build.
> 
> Well... these patches have been banging around in -next for a month or so now.
> As far as I know there haven't been any complaints.  Can we push these for 3.9?
> 

Yes, please I'm waiting for these patches as well. Lets push them this merge
window. I was sure they would get in at 3.8, but they didn't. What's the delay?

[Using this I can fix a theoretical raid corruption in exofs local access, which
 no one really cared because exofs is always accessed via pnfs, which does not
 have that bug]

Thanks
Boaz

> --D
> 

