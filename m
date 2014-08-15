Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaHOSe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:34:28 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47173 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOSe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:34:26 -0400
Message-ID: <53EE52AE.4050006@kernel.dk>
Date: Fri, 15 Aug 2014 12:34:22 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Webb Scales <webbnh@hp.com>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net> <53EE4FDE.2070904@roeck-us.net>
In-Reply-To: <53EE4FDE.2070904@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-15 12:22, Guenter Roeck wrote:
> ping ... the problem fixed by this patch still affects the upstream kernel
> (v3.16-11383-gc9d2642) as well as -next (20140815).

James, could you upstream this one in time for -rc1?

-- 
Jens Axboe

