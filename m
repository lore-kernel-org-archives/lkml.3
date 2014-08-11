Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaHKQVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:21:53 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62862 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaHKQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:21:52 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E8ED9D.7030809@roeck-us.net>
Date: Mon, 11 Aug 2014 09:21:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Venkatesh Srinivas <venkateshs@google.com>, Jens Axboe <axboe@kernel.dk>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Webb Scales <webbnh@hp.com>
Subject: Re: [PATCH] scsi: Fix qemu boot hang problem
References: <1407675265-29192-1-git-send-email-linux@roeck-us.net>	<53E8CF41.2050300@kernel.dk> <CAHdzE-_uFg5m+mr+itugeZwOTqMtLXB=AR01ZsH=yaobez4aew@mail.gmail.com>
In-Reply-To: <CAHdzE-_uFg5m+mr+itugeZwOTqMtLXB=AR01ZsH=yaobez4aew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 08:33 AM, Venkatesh Srinivas wrote:
> Should we wrap the sdev->device_busy read and test in a new
> scsi_device_busy(), so as to preserve the old polarity?
>
I don't see a difference in polarity, or at least replacing '== 0' with '!'
is not a reverse in polarity for me. Anyway, I don't really care if
or how this is wrapped, as long as it is getting fixed.

Thanks,
Guenter

