Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab3DOTFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:05:50 -0400
Received: from masquerade.micron.com ([137.201.242.130]:22330 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290Ab3DOTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:05:49 -0400
Message-ID: <516C4F87.2050104@micron.com>
Date: Tue, 16 Apr 2013 00:35:43 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>
Subject: Re: [PATCH 2/2] mtip32xx: mtip32xx: Disable TRIM support
References: <51685232.2040209@micron.com> <20130414082522.GE12244@kernel.dk>
In-Reply-To: <20130414082522.GE12244@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19798.007
X-TM-AS-Result: No-6.597800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/14/2013 1:55 PM, Jens Axboe wrote:

> On Fri, Apr 12 2013, Asai Thambi S P wrote:
>>
>> Temporarily disabling TRIM support until TRIM related issues
>> are addressed in the firmware.
> 
> How serious is this? We do have released kernels out there with the
> driver, you might want to consider a stable backport too.
> 
> Anyway, applied for 3.10.
> 

Added TRIM support in 3.9 merge window. If this trivial change could be
pushed, it would be good. Otherwise, I can backport to stable 3.9 when released.

--
regards,
asai
