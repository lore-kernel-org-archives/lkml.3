Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaDVBC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:02:28 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48098 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaDVBC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:02:26 -0400
Message-ID: <5355BF9C.5020107@kernel.dk>
Date: Mon, 21 Apr 2014 19:02:20 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH RESEND 0/2] : block: Use pci_enable_msix_exact()
References: <cover.1398093399.git.agordeev@redhat.com>
In-Reply-To: <cover.1398093399.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-21 09:19, Alexander Gordeev wrote:
> Hi Jens,
>
> The series is against v3.15-rc1. The patches complete converison
> of block layer device drivers to the new MSI initialization API.

Thanks, applied for 3.16.

-- 
Jens Axboe

