Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaG2NtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaG2NtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:49:10 -0400
Message-ID: <53D7A62D.2090709@redhat.com>
Date: Tue, 29 Jul 2014 15:48:29 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Subject: Re: [PATCH v2 RESEND 17/23] pm8001: Fix invalid return when request_irq()
 failed
References: <cover.1405533479.git.agordeev@redhat.com> <5ecd9b80f705545c3dc85b2a4ae63a8ac3df8105.1405533479.git.agordeev@redhat.com> <53D79DE2.9000702@redhat.com> <20140729132020.GA7714@infradead.org>
In-Reply-To: <20140729132020.GA7714@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 03:20 PM, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 03:13:06PM +0200, Tomas Henzl wrote:
>> Hi, 
>> patch looks good.
>>
>> A correction in pm8001_request_irq might be added too to allow 
>> the INT-X path when pm8001_setup_msix fails, but that is not part 
>> of this fix.
>
> There's actually an equivalent fix already in through one of the
> previous pm8001 updates, so I skipped this one even if it already had an
> ACK.  The following pm8001 applied just fine, though.  Take a look, as
> I've already pushed out the updated drivers branch.

I'm a bit confused - you were not commenting my text above I think?

I see in drivers-for-3.17 this patch already applied 5607de7
but not yet the next one (18/23) which also has a review, is there another ack needed?

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

