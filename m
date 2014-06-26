Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaFZQLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:11:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34240 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbaFZQLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:11:14 -0400
Message-ID: <53AC461D.6080004@kernel.dk>
Date: Thu, 26 Jun 2014 10:11:09 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>, Joe Lawrence <joe.lawrence@stratus.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com> <x49wqc34psf.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49wqc34psf.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-26 10:08, Jeff Moyer wrote:
> Joe Lawrence <joe.lawrence@stratus.com> writes:
>
>> v1->v2: incorporate Jeff's feedback in bsg_map_hdr() and Reviewed-by
>>          tags.
>>
>> Joe Lawrence (2):
>>    block,scsi: verify return pointer from blk_get_request
>>    block,scsi: convert and handle ERR_PTR from blk_get_request
>
> Jens,
>
> Can you pick this series up?  It actually fixes a NULL pointer
> dereference that can happen if (for example) a usb optical drive is
> removed while an application is using it.

Yeah I'll pick it up, opening up the 3.17 branches soon.

-- 
Jens Axboe

