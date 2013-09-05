Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164Ab3IEMC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:02:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761630Ab3IEMCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:02:55 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: OS Engineering <osengineering@stec-inc.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe\@kernel.dk" <axboe@kernel.dk>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad>
	<x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com>
	<26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 05 Sep 2013 08:00:51 -0400
In-Reply-To: <26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad> (OS
	Engineering's message of "Thu, 5 Sep 2013 05:31:05 +0000")
Message-ID: <x4938pjbhqk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OS Engineering <osengineering@stec-inc.com> writes:

> Hi Jeff,
>
> Thank you for reviewing the patch.

No problem.  Jens, any objection to queueing this up for 3.12?

Cheers,
Jeff

> ________________________________________
> From: Jeff Moyer [jmoyer@redhat.com]
> Sent: Friday, August 30, 2013 6:18 AM
> To: OS Engineering
> Cc: linux-kernel@vger.kernel.org; axboe@kernel.dk; Akhil Bhansali; Ramprasad Chinthekindi; Amit Phansalkar
> Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
>
> OS Engineering <osengineering@stec-inc.com> writes:
>
>> Hello All,
>>
>> We are submitting device driver for sTec's PCIe flash card named "Kronos" for inclusion in linux kernel.
>>
>> Thanks.
>> Akhil Bhansali.
>> --
>> From 3861f12cd99a9b1ba561296790ec482a75eeacd1 Mon Sep 17 00:00:00 2001
>> From: Akhil Bhansali <abhansali@stec-inc.com>
>> Date: Fri, 30 Aug 2013 11:32:49 +0530
>> Subject: [PATCH] Patch for pcie device driver from sTec Inc.
>>
>> This patch adds "skd", a driver for sTec's PCIe flash cards named
>> Kronos.
>> Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
>> Signed-off-by: Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>
>
> This looks good to me.  It's nice to see another open source PCIe SSD
> driver submitted!
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
