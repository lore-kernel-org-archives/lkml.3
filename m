Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaHOSrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:47:07 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52616 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHOSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:47:05 -0400
Message-ID: <53EE55AA.2010209@kernel.dk>
Date: Fri, 15 Aug 2014 12:47:06 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: dm: propagate QUEUE_FLAG_NO_SG_MERGE
References: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>	<20140811011108.GA13946@redhat.com> <x49mwbbozsb.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mwbbozsb.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 08:40 AM, Jeff Moyer wrote:
> Mike Snitzer <snitzer@redhat.com> writes:
> 
>> Hi Jeff,
>>
>> Thanks for the patch.  But I think you need the following tweak.
>> Otherwise if the DM table is reloaded (and the devices in the table
>> happen to change) the flag won't get cleared as needed.
> 
> Ah, thanks for the education.  Looks good to me.

Ditto, you can add my acked-by, if not already queued up etc.

-- 
Jens Axboe

