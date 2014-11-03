Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaKCScK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:32:10 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44923 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaKCScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:32:08 -0500
Message-ID: <5457CA25.4080207@kernel.dk>
Date: Mon, 03 Nov 2014 11:32:05 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcsOpIEJhdWVy?= <monotek23@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>,
        =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Subject: Re: [PATCH] EnhanceIO ssd caching software
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD> <545754C6.5000304@gmail.com> <5457C4D0.3090306@kernel.dk> <5457C657.9020305@gmail.com>
In-Reply-To: <5457C657.9020305@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-03 11:15, André Bauer wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Am 03.11.2014 um 19:09 schrieb Jens Axboe:
>> Is stec still maintaining it? I've heard nothing about it since,
>> and even their pci flash driver seems to be unmaintained.
>
> I don´t think so, because stec inc. was aquired by WD. Info:
> http://www.wdc.com/en/company/pressroom/releases/?release=e7e8a0f2-b89f-4b85-8b1b-387f9a4b0818

Yes, I'm well aware of that. However, a recent experience in this area 
would seem to back up my above note. If you're interested in enhanceio 
being resubmitted for review and evaluation, then I suggest you talk to 
stec/wdc/hgst and find out what their plans are. As it stands, it's not 
going anywhere.

-- 
Jens Axboe

