Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3GBD2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:28:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44772 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3GBD2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:28:00 -0400
Message-ID: <51D248B8.3030701@codeaurora.org>
Date: Tue, 02 Jul 2013 08:57:52 +0530
From: Sujit Reddy Thumma <sthumma@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'James Bottomley'" <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: Fix possible sleep in invalid context
References: <1372692515-31969-1-git-send-email-sthumma@codeaurora.org> <51D24336.5020504@intel.com>
In-Reply-To: <51D24336.5020504@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2013 8:34 AM, Aaron Lu wrote:
>> Fix this by releasing spin_lock_irq() before calling
>> >pm_runtime_autosuspend() in blk_post_runtime_resume().
> Hi Sujit,
>
> Thanks for testing out block layer runtime PM!
>
> As for the problem here, it is already fixed by:
>
> commit c60855cdb976c632b3bf8922eeab8a0e78edfc04
> Author: Aaron Lu<aaron.lu@intel.com>
> Date:   Fri May 17 15:47:20 2013 +0800
>
>      blkpm: avoid sleep when holding queue lock

Thanks Aaron. I see that is merged in 3.10-rc6.
Please ignore this patch.

-- 
Regards,
Sujit
