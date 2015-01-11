Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbbAKJas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 04:30:48 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56009 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbAKJap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 04:30:45 -0500
Message-ID: <54B242C1.6070301@plexistor.com>
Date: Sun, 11 Jan 2015 11:30:41 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHSET 0/4 v4] brd: partition fixes
References: <54AD5893.9040701@plexistor.com> <54AEEEF3.8040300@fb.com>
In-Reply-To: <54AEEEF3.8040300@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 10:56 PM, Jens Axboe wrote:
> On 01/07/2015 09:02 AM, Boaz Harrosh wrote:
>> Jens Hi
>>
>> Currently brd has multiple bugs when trying to use partitions. After this
>> set all known problems are solved. Please see individual patch for description
>> of the problem.
>> (Another merge window, another patchset send. I wish you would tell me to
>>  just *uck-off, instead of this silence. What is so big a deal about this
>>  simple bug fixes.)
> 
> Calm down. All previous series posted have needed changes. And you
> always seem to post after a merge window has closed, so your timing is
> bad. Finally looks like it's good to go, so I've merged it for this series.
> 

Thanks
Boaz
