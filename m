Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaHOT0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:26:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50824 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaHOT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:26:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53EE5EFA.30102@roeck-us.net>
Date: Fri, 15 Aug 2014 12:26:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Webb Scales <webbnh@hp.com>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net> <53EE4FDE.2070904@roeck-us.net> <53EE52AE.4050006@kernel.dk> <20140815192253.GA22752@lst.de>
In-Reply-To: <20140815192253.GA22752@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 12:22 PM, Christoph Hellwig wrote:
> On Fri, Aug 15, 2014 at 12:34:22PM -0600, Jens Axboe wrote:
>> On 2014-08-15 12:22, Guenter Roeck wrote:
>>> ping ... the problem fixed by this patch still affects the upstream kernel
>>> (v3.16-11383-gc9d2642) as well as -next (20140815).
>>
>> James, could you upstream this one in time for -rc1?
>
> It's in the core-for-3.17 updates I sent to James yesterday, just needs to
> be forwarded..
>

Great, thanks a lot!

Guenter

