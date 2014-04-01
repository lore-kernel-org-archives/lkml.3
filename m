Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaDAAZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:25:34 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:37746 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaDAAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140331145625.GA10791@infradead.org>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
	<20140331145625.GA10791@infradead.org>
Date: Tue, 1 Apr 2014 09:19:12 +0900
Message-ID: <CAKYAXd8adbqepWeDADDtbzk7bTrhXK0CccgewNDsqu0u+HnC4g@mail.gmail.com>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>,
        =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-31 23:56 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
> On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
>> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
>> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
>> in between the file within the range specified by offset and len. User can
>> write new data in this space. e.g. ads.
>> Like collapse range, currently we have the limitation that offset and len
>> should be block size aligned for both XFS and Ext4.
>
> Btw, I remember Samsung also had an ioctl for XFS to split a file into
> two without moving the data, do you plan to submit that one as well?
>
Hi Christoph.
Sure, I'm planning to introduce FS_IOC_MOVE_DATA ioctl that can split
file as well as merging for xfs and ext4.
I already started to implement it. and will post it soon.

Thanks.
